package edu.pitt.cs.cs1635.ant72.assignment2_scribbler;

import android.graphics.Color;

public class Singleton {
    private static Singleton mInstance = null;

    private int color_val;

    private Singleton(){
        color_val = Color.BLACK;
    }

    public static Singleton getInstance(){
        if(mInstance == null){
            mInstance = new Singleton();
        }
        return mInstance;
    }

    public int getColor(){
        return this.color_val;
    }

    public void setColor(int color){
        color_val = color;
    }
}
