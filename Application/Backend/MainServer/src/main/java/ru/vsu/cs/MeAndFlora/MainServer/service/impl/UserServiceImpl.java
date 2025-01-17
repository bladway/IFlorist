package ru.vsu.cs.MeAndFlora.MainServer.service.impl;

import lombok.RequiredArgsConstructor;
import org.apache.commons.validator.routines.InetAddressValidator;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import ru.vsu.cs.MeAndFlora.MainServer.config.component.JwtUtil;
import ru.vsu.cs.MeAndFlora.MainServer.config.exception.AuthException;
import ru.vsu.cs.MeAndFlora.MainServer.config.exception.InputException;
import ru.vsu.cs.MeAndFlora.MainServer.config.exception.JwtException;
import ru.vsu.cs.MeAndFlora.MainServer.config.exception.RightsException;
import ru.vsu.cs.MeAndFlora.MainServer.config.property.ErrorPropertiesConfig;
import ru.vsu.cs.MeAndFlora.MainServer.config.states.UserRole;
import ru.vsu.cs.MeAndFlora.MainServer.controller.dto.DiJwtDto;
import ru.vsu.cs.MeAndFlora.MainServer.controller.dto.StringDto;
import ru.vsu.cs.MeAndFlora.MainServer.controller.dto.UserInfoDto;
import ru.vsu.cs.MeAndFlora.MainServer.controller.dto.UserInfoDtosDto;
import ru.vsu.cs.MeAndFlora.MainServer.repository.MafUserRepository;
import ru.vsu.cs.MeAndFlora.MainServer.repository.USessionRepository;
import ru.vsu.cs.MeAndFlora.MainServer.repository.entity.MafUser;
import ru.vsu.cs.MeAndFlora.MainServer.repository.entity.USession;
import ru.vsu.cs.MeAndFlora.MainServer.service.UserService;

import java.time.OffsetDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class UserServiceImpl implements UserService {

    private final ErrorPropertiesConfig errorPropertiesConfig;

    private final MafUserRepository mafUserRepository;

    private final USessionRepository uSessionRepository;

    private final JwtUtil jwtUtil;

    private void validateLogin(String login) {
        if (login.length() < 6 || login.length() > 25) {
            throw new AuthException(
                    errorPropertiesConfig.getBadlogin(),
                    "login does not match expected length: 6 - 25"
            );
        }
    }

    private void validateLoginDuplication(String login) {
        mafUserRepository.findByLogin(login).ifPresent(
                mafUser -> {
                    throw new AuthException(
                            errorPropertiesConfig.getDoublelogin(),
                            "such login exists in the database"
                    );
                }
        );
    }

    private void validatePassword(String password) {
        if (password.length() < 6 || password.length() > 25) {
            throw new AuthException(
                    errorPropertiesConfig.getBadpassword(),
                    "password does not match expected length: 6 - 25"
            );
        }
    }

    private void validateIpAddress(String ipAddress) {
        if (!InetAddressValidator.getInstance().isValidInet4Address(ipAddress)) {
            throw new AuthException(
                    errorPropertiesConfig.getBadip(),
                    "ip address does not match expected template: 0-255.0-255.0-255.0-255"
            );
        }
    }

    @Override
    public DiJwtDto register(String login, String password, String ipAddress) {
        validateLogin(login);
        validatePassword(password);
        validateIpAddress(ipAddress);
        validateLoginDuplication(login);

        MafUser user = mafUserRepository.save(new MafUser(login, password, UserRole.USER.getName()));

        USession session = uSessionRepository.save(
                new USession(
                        jwtUtil.generateToken(),
                        jwtUtil.generateRToken(),
                        ipAddress,
                        user
                )
        );

        return new DiJwtDto(session.getJwt(), session.getJwtR());
    }

    @Override
    public DiJwtDto login(String login, String password, String ipAddress) {
        validateLogin(login);
        validatePassword(password);
        validateIpAddress(ipAddress);

        Optional<MafUser> ifuser = mafUserRepository.findByLogin(login);

        if (ifuser.isEmpty()) {
            throw new AuthException(
                    errorPropertiesConfig.getUsrnotfound(),
                    "this user has not found in the database"
            );
        }

        MafUser user = ifuser.get();

        if (!user.getPassword().equals(password)) {
            throw new AuthException(
                    errorPropertiesConfig.getBadpassword(),
                    "provided password does not match user password"
            );
        }

        USession session = uSessionRepository.save(
                new USession(
                        jwtUtil.generateToken(),
                        jwtUtil.generateRToken(),
                        ipAddress,
                        user
                )
        );

        return new DiJwtDto(session.getJwt(), session.getJwtR());
    }

    @Override
    public DiJwtDto anonymousLogin(String ipAddress) {
        validateIpAddress(ipAddress);

        USession session = uSessionRepository.save(
                new USession(
                        jwtUtil.generateToken(),
                        jwtUtil.generateRToken(),
                        ipAddress,
                        null
                )
        );

        return new DiJwtDto(session.getJwt(), session.getJwtR());
    }

    @Override
    public DiJwtDto refresh(String jwtR) {

        Optional<USession> ifsession = uSessionRepository.findByJwtR(jwtR);

        if (ifsession.isEmpty()) {
            throw new JwtException(
                    errorPropertiesConfig.getBadjwtr(),
                    "provided refresh jwt is not valid"
            );
        }

        USession session = ifsession.get();

        if (jwtUtil.ifJwtRExpired(session.getJwtCreatedTime())) {
            throw new JwtException(
                    errorPropertiesConfig.getExpiredr(),
                    "refresh jwt lifetime has ended, relogin, please"
            );
        }

        session.setJwt(jwtUtil.generateToken());
        session.setJwtR(jwtUtil.generateRToken());
        session.setJwtCreatedTime(OffsetDateTime.now());

        session = uSessionRepository.save(session);

        return new DiJwtDto(session.getJwt(), session.getJwtR());
    }

    @Override
    public StringDto change(String jwt, String newLogin, String newPassword, String oldPassword) {
        boolean changeLogin = false;
        boolean changePassword = false;
        validatePassword(oldPassword);
        if (!newLogin.isEmpty()) {
            validateLogin(newLogin);
            changeLogin = true;
        }
        if (!newPassword.isEmpty()) {
            validatePassword(newPassword);
            changePassword = true;
        }
        if (!(changeLogin || changePassword)) {
            throw new InputException(
                    errorPropertiesConfig.getChangeisnull(),
                    "provide at least one: newLogin or newPassword"
            );
        }

        Optional<USession> ifsession = uSessionRepository.findByJwt(jwt);

        if (ifsession.isEmpty()) {
            throw new JwtException(
                    errorPropertiesConfig.getBadjwt(),
                    "provided jwt is not valid"
            );
        }

        USession session = ifsession.get();

        if (jwtUtil.ifJwtExpired(session.getJwtCreatedTime())) {
            throw new JwtException(
                    errorPropertiesConfig.getExpired(),
                    "jwt lifetime has ended, get a new one by refresh token"
            );
        }

        if (!(session.getUser() != null && session.getUser().getRole().equals(UserRole.USER.getName()))) {
            throw new RightsException(
                    errorPropertiesConfig.getNorights(),
                    "only user can change account data"
            );
        }

        MafUser user = session.getUser();

        if (!user.getPassword().equals(oldPassword)) {
            throw new AuthException(
                    errorPropertiesConfig.getBadpassword(),
                    "provided old password is wrong"
            );
        }

        if (changeLogin) {
            user.setLogin(newLogin);
        }
        if (changePassword) {
            user.setPassword(newPassword);
        }

        user = mafUserRepository.save(user);

        return new StringDto(user.getLogin());
    }

    @Override
    public StringDto createUser(String jwt, String login, String password, String role) {
        validateLogin(login);
        validatePassword(password);
        validateLoginDuplication(login);

        Optional<USession> ifsession = uSessionRepository.findByJwt(jwt);

        if (ifsession.isEmpty()) {
            throw new JwtException(
                    errorPropertiesConfig.getBadjwt(),
                    "provided jwt is not valid"
            );
        }

        USession session = ifsession.get();

        if (jwtUtil.ifJwtExpired(session.getJwtCreatedTime())) {
            throw new JwtException(
                    errorPropertiesConfig.getExpired(),
                    "jwt lifetime has ended, get a new one by refresh token"
            );
        }

        if (!(session.getUser() != null && session.getUser().getRole().equals(UserRole.ADMIN.getName()))) {
            throw new RightsException(
                    errorPropertiesConfig.getNorights(),
                    "only admin can create users"
            );
        }

        MafUser user;
        if (!(role.equals(UserRole.USER.getName()) || role.equals(UserRole.BOTANIST.getName()))) {
            throw new InputException(
                    errorPropertiesConfig.getInvalidinput(),
                    "provided role of user is not valid"
            );
        }

        user = mafUserRepository.save(new MafUser(login, password, role));

        return new StringDto(user.getLogin());

    }

    @Override
    public StringDto deleteUser(String jwt, String login) {
        validateLogin(login);

        Optional<USession> ifsession = uSessionRepository.findByJwt(jwt);

        if (ifsession.isEmpty()) {
            throw new JwtException(
                    errorPropertiesConfig.getBadjwt(),
                    "provided jwt is not valid"
            );
        }

        USession session = ifsession.get();

        if (jwtUtil.ifJwtExpired(session.getJwtCreatedTime())) {
            throw new JwtException(
                    errorPropertiesConfig.getExpired(),
                    "jwt lifetime has ended, get a new one by refresh token"
            );
        }

        if (!(session.getUser() != null && session.getUser().getRole().equals(UserRole.ADMIN.getName()))) {
            throw new RightsException(
                    errorPropertiesConfig.getNorights(),
                    "only admin can delete users"
            );
        }

        Optional<MafUser> ifuser = mafUserRepository.findByLogin(login);

        if (ifuser.isEmpty()) {
            throw new InputException(
                    errorPropertiesConfig.getInvalidinput(),
                    "user with provided login not found to delete"
            );
        }

        MafUser user = ifuser.get();

        if (user.getRole().equals(UserRole.ADMIN.getName())) {
            throw new RightsException(
                    errorPropertiesConfig.getNorights(),
                    "no one can delete admin accounts"
            );
        }

        mafUserRepository.delete(user);

        return new StringDto(user.getLogin());

    }

    @Override
    public UserInfoDto getUserInfo(String jwt) {
        Optional<USession> ifsession = uSessionRepository.findByJwt(jwt);

        if (ifsession.isEmpty()) {
            throw new JwtException(
                    errorPropertiesConfig.getBadjwt(),
                    "provided jwt is not valid"
            );
        }

        USession session = ifsession.get();

        if (jwtUtil.ifJwtExpired(session.getJwtCreatedTime())) {
            throw new JwtException(
                    errorPropertiesConfig.getExpired(),
                    "jwt lifetime has ended, get a new one by refresh token"
            );
        }

        if (session.getUser() == null) {
            return new UserInfoDto("Анонимный пользователь", "Анонимный пользователь");
        }

        MafUser user = session.getUser();

        return new UserInfoDto(user.getLogin(), user.getRole());
    }

    public UserInfoDtosDto getAllUserInfo(String jwt, int page, int size) {
        Optional<USession> ifsession = uSessionRepository.findByJwt(jwt);

        if (ifsession.isEmpty()) {
            throw new JwtException(
                    errorPropertiesConfig.getBadjwt(),
                    "provided jwt is not valid"
            );
        }

        USession session = ifsession.get();

        if (jwtUtil.ifJwtExpired(session.getJwtCreatedTime())) {
            throw new JwtException(
                    errorPropertiesConfig.getExpired(),
                    "jwt lifetime has ended, get a new one by refresh token"
            );
        }

        if (!(session.getUser() != null && session.getUser().getRole().equals(UserRole.ADMIN.getName()))) {
            throw new RightsException(
                    errorPropertiesConfig.getNorights(),
                    "only admin can get a list of all users"
            );
        }

        List<String> userAndBotRoles = new ArrayList<>();
        userAndBotRoles.add(UserRole.USER.getName());
        userAndBotRoles.add(UserRole.BOTANIST.getName());

        Page<MafUser> mafUserPage = mafUserRepository.findByRoleIn(
                userAndBotRoles,
                PageRequest.of(page, size, Sort.by("role").and(Sort.by("login")))
        );
        List<UserInfoDto> userList = new ArrayList<>();
        mafUserPage.forEach(user -> userList.add(new UserInfoDto(user.getLogin(), user.getRole())));

        return new UserInfoDtosDto(userList);
    }

}
