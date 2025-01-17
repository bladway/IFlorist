package ru.vsu.cs.MeAndFlora.MainServer.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import ru.vsu.cs.MeAndFlora.MainServer.config.exception.*;
import ru.vsu.cs.MeAndFlora.MainServer.config.property.ErrorPropertiesConfig;
import ru.vsu.cs.MeAndFlora.MainServer.controller.dto.*;
import ru.vsu.cs.MeAndFlora.MainServer.service.AdvertisementService;
import ru.vsu.cs.MeAndFlora.MainServer.service.UserService;

@RequiredArgsConstructor
@RestController
@Tag(name = "Controller for working with user accounts")
@RequestMapping(path = "/user")
public class UserController {

    private static final Logger userLogger =
            LoggerFactory.getLogger(UserController.class);

    private final ErrorPropertiesConfig errorPropertiesConfig;

    private final UserService userService;

    private final AdvertisementService advertisementService;

    private final ObjectMapper objectMapper;

    @Operation(description = "Get. Get user login and role by jwt."
            + " Requires: jwt in header."
            + " Provides: UserInfoDto in body.")
    @GetMapping(
            value = "/byJwt"
    )
    public ResponseEntity<Object> getUserInfo(
            @RequestHeader String jwt
    ) {

        Object body;
        HttpHeaders headers = new HttpHeaders();
        HttpStatus status;

        try {

            UserInfoDto infoDto = userService.getUserInfo(jwt);

            body = infoDto;

            status = HttpStatus.OK;

            userLogger.info(
                    "Get user info with login: {} with role: {} is successful",
                    infoDto.getLogin(),
                    infoDto.getRole()
            );

        } catch (CustomRuntimeException e) {

            body = new ExceptionDto(e.getShortMessage(), e.getMessage(), e.getTimestamp());

            status = e.getClass() == AuthException.class ? HttpStatus.UNAUTHORIZED
                    : e.getClass() == InputException.class ? HttpStatus.BAD_REQUEST
                    : e.getClass() == JwtException.class ? HttpStatus.UNAUTHORIZED
                    : e.getClass() == ObjectException.class ? HttpStatus.NOT_FOUND
                    : e.getClass() == RightsException.class ? HttpStatus.FORBIDDEN
                    : e.getClass() == StateException.class ? HttpStatus.CONFLICT
                    : HttpStatus.INTERNAL_SERVER_ERROR;

            userLogger.warn("{}: {}", e.getShortMessage(), e.getMessage());

        }

        headers.add("jwt", jwt);

        return new ResponseEntity<>(body, headers, status);

    }

    @Operation(description = "Get. Get all users (except admins) by admin to select and delete."
            + " Requires: jwt in header, page and size in query params (optionally)."
            + " Provides: UserInfoDto in body.")
    @GetMapping(
            value = "/allByAdmin"
    )
    public ResponseEntity<Object> getAllUsersInfo(
            @RequestHeader String jwt,
            @RequestParam(required = false, defaultValue = "0") int page,
            @RequestParam(required = false, defaultValue = "10") int size
    ) {

        Object body;
        HttpHeaders headers = new HttpHeaders();
        HttpStatus status;

        try {

            body = userService.getAllUserInfo(jwt, page, size);

            status = HttpStatus.OK;

            userLogger.info(
                    "Get users info, page: {} size: {} is successful",
                    page,
                    size
            );

        } catch (CustomRuntimeException e) {

            body = new ExceptionDto(e.getShortMessage(), e.getMessage(), e.getTimestamp());

            status = e.getClass() == AuthException.class ? HttpStatus.UNAUTHORIZED
                    : e.getClass() == InputException.class ? HttpStatus.BAD_REQUEST
                    : e.getClass() == JwtException.class ? HttpStatus.UNAUTHORIZED
                    : e.getClass() == ObjectException.class ? HttpStatus.NOT_FOUND
                    : e.getClass() == RightsException.class ? HttpStatus.FORBIDDEN
                    : e.getClass() == StateException.class ? HttpStatus.CONFLICT
                    : HttpStatus.INTERNAL_SERVER_ERROR;

            userLogger.warn("{}: {}", e.getShortMessage(), e.getMessage());

        }

        headers.add("jwt", jwt);

        return new ResponseEntity<>(body, headers, status);

    }



    /*@Operation(description = "Get. Get all users by admin."
            + " Requires: jwt in header."
            + " Provides: StringsDto with list of flora type names in body")
    @GetMapping(
            value = "/users",
            consumes = {MediaType.MULTIPART_FORM_DATA_VALUE}
    )
    public ResponseEntity<Object> getFloraTypes(
            @RequestHeader String jwt
    ) {

        Object body;
        HttpHeaders headers = new HttpHeaders();
        HttpStatus status;

        try {

            body = floraService.getTypes(jwt);

            status = HttpStatus.OK;

            floraLogger.info(
                    "Get types of flora is successful"
            );

        } catch (JwtException | RightsException | ObjectException e) {

            body = new ExceptionDto(e.getShortMessage(), e.getMessage(), e.getTimestamp());

            status = e.getClass() == JwtException.class ?
                    HttpStatus.UNAUTHORIZED : e.getClass() == RightsException.class ?
                    HttpStatus.FORBIDDEN : e.getClass() == ObjectException.class ?
                    HttpStatus.NOT_FOUND : HttpStatus.INTERNAL_SERVER_ERROR;

            floraLogger.warn("{}: {}", e.getShortMessage(), e.getMessage());

        }

        headers.add("jwt", jwt);

        return new ResponseEntity<>(body, headers, status);

    }*/

    @Operation(description = "Post. Create new user with role."
            + " Requires: jwt in header, UserDto in body."
            + " Provides: StringDto with username of created user.")
    @PostMapping(
            value = "/create"
    )
    public ResponseEntity<Object> createNewUser(
            @RequestHeader String jwt,
            @RequestBody UserDto userDto
    ) {

        Object body;
        HttpHeaders headers = new HttpHeaders();
        HttpStatus status;

        try {

            body = userService.createUser(
                    jwt,
                    userDto.getLogin(),
                    userDto.getPassword(),
                    userDto.getRole()
            );

            status = HttpStatus.OK;

            userLogger.info(
                    "Create user: {} with role: {} is successful",
                    userDto.getLogin(),
                    userDto.getRole()
            );

        } catch (CustomRuntimeException e) {

            body = new ExceptionDto(e.getShortMessage(), e.getMessage(), e.getTimestamp());

            status = e.getClass() == AuthException.class ? HttpStatus.UNAUTHORIZED
                    : e.getClass() == InputException.class ? HttpStatus.BAD_REQUEST
                    : e.getClass() == JwtException.class ? HttpStatus.UNAUTHORIZED
                    : e.getClass() == ObjectException.class ? HttpStatus.NOT_FOUND
                    : e.getClass() == RightsException.class ? HttpStatus.FORBIDDEN
                    : e.getClass() == StateException.class ? HttpStatus.CONFLICT
                    : HttpStatus.INTERNAL_SERVER_ERROR;

            userLogger.warn("{}: {}", e.getShortMessage(), e.getMessage());

        }

        headers.add("jwt", jwt);

        return new ResponseEntity<>(body, headers, status);

    }

    @Operation(description = "Post. User has seen the advertisement."
            + " Requires: jwt in header."
            + " Provides: LongDto with sessionId.")
    @PostMapping(
            value = "/seeAdvert"
    )
    public ResponseEntity<Object> seeAdvertisement(
            @RequestHeader String jwt
    ) {

        Object body;
        HttpHeaders headers = new HttpHeaders();
        HttpStatus status;

        try {

            LongDto sessionIdDto = advertisementService.addAdvertisement(jwt);

            body = sessionIdDto;

            status = HttpStatus.OK;

            userLogger.info(
                    "User in session: {} has seen the advertisement",
                    sessionIdDto.getNumber()
            );

        } catch (CustomRuntimeException e) {

            body = new ExceptionDto(e.getShortMessage(), e.getMessage(), e.getTimestamp());

            status = e.getClass() == AuthException.class ? HttpStatus.UNAUTHORIZED
                    : e.getClass() == InputException.class ? HttpStatus.BAD_REQUEST
                    : e.getClass() == JwtException.class ? HttpStatus.UNAUTHORIZED
                    : e.getClass() == ObjectException.class ? HttpStatus.NOT_FOUND
                    : e.getClass() == RightsException.class ? HttpStatus.FORBIDDEN
                    : e.getClass() == StateException.class ? HttpStatus.CONFLICT
                    : HttpStatus.INTERNAL_SERVER_ERROR;

            userLogger.warn("{}: {}", e.getShortMessage(), e.getMessage());

        }

        headers.add("jwt", jwt);

        return new ResponseEntity<>(body, headers, status);

    }

    @Operation(description = "Delete. Delete user (botanic or ordinal user) by admin."
            + " Requires: jwt in header, StringDto with username in body."
            + " Provides: StringDto with username of deleted user.")
    @DeleteMapping(
            value = "/delete"
    )
    public ResponseEntity<Object> deleteUser(
            @RequestHeader String jwt,
            @RequestBody StringDto stringDto
    ) {

        Object body;
        HttpHeaders headers = new HttpHeaders();
        HttpStatus status;

        try {

            body = userService.deleteUser(jwt, stringDto.getString());

            status = HttpStatus.OK;

            userLogger.info(
                    "Delete user: {} is successful",
                    stringDto.getString()
            );

        } catch (CustomRuntimeException e) {

            body = new ExceptionDto(e.getShortMessage(), e.getMessage(), e.getTimestamp());

            status = e.getClass() == AuthException.class ? HttpStatus.UNAUTHORIZED
                    : e.getClass() == InputException.class ? HttpStatus.BAD_REQUEST
                    : e.getClass() == JwtException.class ? HttpStatus.UNAUTHORIZED
                    : e.getClass() == ObjectException.class ? HttpStatus.NOT_FOUND
                    : e.getClass() == RightsException.class ? HttpStatus.FORBIDDEN
                    : e.getClass() == StateException.class ? HttpStatus.CONFLICT
                    : HttpStatus.INTERNAL_SERVER_ERROR;

            userLogger.warn("{}: {}", e.getShortMessage(), e.getMessage());

        }

        headers.add("jwt", jwt);

        return new ResponseEntity<>(body, headers, status);

    }


}