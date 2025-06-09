package websocket;

import jakarta.websocket.*;
import jakarta.websocket.server.PathParam;
import jakarta.websocket.server.ServerEndpoint;

import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

@ServerEndpoint("/private/{user}")
public class PrivateChat {

    private static final Map<String, Session> userSessions = new ConcurrentHashMap<>();

    @OnOpen
    public void onOpen(Session session, @PathParam("user") String username) {
        userSessions.put(username, session);
        System.out.println(username + " connected");
    }

    @OnMessage
    public void onMessage(String message, @PathParam("user") String sender) {
        String[] parts = message.split(":", 2);
        if (parts.length < 2) return;

        String recipient = parts[0];
        String msg = parts[1];

        Session recipientSession = userSessions.get(recipient);
        if (recipientSession != null && recipientSession.isOpen()) {
            recipientSession.getAsyncRemote().sendText(sender + ": " + msg);
        }
    }

    @OnClose
    public void onClose(Session session, @PathParam("user") String username) {
        userSessions.remove(username);
        System.out.println(username + " disconnected");
    }

    @OnError
    public void onError(Session session, Throwable throwable) {
        throwable.printStackTrace();
    }
}
