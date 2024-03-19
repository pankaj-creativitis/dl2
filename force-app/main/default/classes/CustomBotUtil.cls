public without sharing class CustomBotUtil {
    
    public static Integer generateRandomCode(){
        Double random = Math.random() * 1000000;
        return random.intValue();
    }

}