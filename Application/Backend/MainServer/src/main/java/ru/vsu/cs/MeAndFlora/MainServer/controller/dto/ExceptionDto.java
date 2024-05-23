package ru.vsu.cs.MeAndFlora.MainServer.controller.dto;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.OffsetDateTime;

@Data
@NoArgsConstructor
public class ExceptionDto {

    public ExceptionDto(String shortMessage, String message, OffsetDateTime timestamp) {
        this.shortMessage = shortMessage;
        this.message = message;
        this.timestamp = timestamp;
    }

    private String shortMessage;
    private String message;
    @JsonProperty("timestamp")
    @JsonFormat(pattern = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSXXX")
    private OffsetDateTime timestamp;

}
