package com.example.bermtec;

import com.amazonaws.services.lambda.runtime.Context;

public class GreetingController {
    public String greeting(String input, Context context) {
        context.getLogger().log("User Input : " + input);
        return "Please Welcome Aboard " + input;
    }
}