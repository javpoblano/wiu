package com.fullstack.javpoblano.wiu;

/**
 * Created by javpoblano on 4/16/16.
 */
public interface AccelerometerListener {

    public void onAccelerationChanged(float x, float y, float z);

    public void onShake(float force);

}