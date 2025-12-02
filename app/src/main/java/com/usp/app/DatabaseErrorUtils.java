package com.usp.app;

import reactor.core.Exceptions;

public final class DatabaseErrorUtils {

    private DatabaseErrorUtils() {}

    /**
     * Retorna a causa raiz real (normalmente o erro do banco).
     */
    public static Throwable rootCause(Throwable error) {
        Throwable root = Exceptions.unwrap(error);

        while (root.getCause() != null && root.getCause() != root) {
            root = root.getCause();
        }

        return root;
    }

    /**
     * Retorna só a mensagem do banco.
     */
    public static String extractMessage(Throwable error) {
        Throwable root = rootCause(error);
        return root.getMessage() != null ? root.getMessage() : "Erro desconhecido no banco de dados";
    }
}
