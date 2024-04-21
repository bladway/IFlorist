package ru.vsu.cs.MeAndFlora.MainServer.exception;

import java.time.OffsetDateTime;

public class ApplicationException extends RuntimeException {

    public ApplicationException(String shortmessage, String message) {
        super(message);
        this.shortMessage = shortmessage;
        this.timestamp = OffsetDateTime.now();
    }

    private String shortMessage;

    private OffsetDateTime timestamp;

    public String getShortMessage() {
        return shortMessage;
    }

    public OffsetDateTime getTimestamp() {
        return timestamp;
    }
}
