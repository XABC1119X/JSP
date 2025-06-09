package model;

import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

public class UserDatabase {
    private static Map<String, String> users = new ConcurrentHashMap<>();

    // 新增使用者
    public static boolean register(String username, String password) {
        if (users.containsKey(username)) return false;
        users.put(username, password);
        return true;
    }

    // 驗證登入
    public static boolean authenticate(String username, String password) {
        return password.equals(users.get(username));
    }

    // 是否已註冊
    public static boolean exists(String username) {
        return users.containsKey(username);
    }
}
