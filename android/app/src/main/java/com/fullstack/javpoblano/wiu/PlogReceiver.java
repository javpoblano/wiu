package com.fullstack.javpoblano.wiu;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.net.Uri;
import android.telephony.SmsManager;
import android.util.Log;
import android.widget.Toast;

import java.util.Timer;
import java.util.TimerTask;
import java.util.logging.Handler;

/**
 * Created by javpoblano on 4/16/16.
 */
public class PlogReceiver extends BroadcastReceiver {
    Context context;
    Timer timer;
    TimerTask timerTask;
    public OnTaskCompleted listener;
    Handler handler;
    int cont = 0;

    public PlogReceiver(OnTaskCompleted listener)
    {
        this.listener=listener;
    }


    public PlogReceiver()
    {
    }

    @Override
    public void onReceive(Context context, Intent intent) {
        if (intent.getAction().equals(Intent.ACTION_HEADSET_PLUG)) {
            int state = intent.getIntExtra("state", -1);
            this.context = context;
            switch (state) {
                case 0:
                    Log.d("TAG", "Headset is unplugged");
                        sendSMS();

                    //sendWhats(context);
                    break;
                case 1:
                    Log.d("TAG", "Headset is plugged");
                    stoptimertask();
                    Toast.makeText(context, "ALARMA ARMADA", Toast.LENGTH_SHORT).show();
                    break;
                default:
                    Log.d("TAG", "I have no idea what the headset state is");
            }
        }
    }

    public void sendSMS() {
        try
        {
            SmsManager smsManager = SmsManager.getDefault();
            smsManager.sendTextMessage("5550592953", null, "Javier" + " tiene una emergencia", null, null);
            smsManager.sendTextMessage("5519532777", null, "Javier" + " tiene una emergencia", null, null);
            smsManager.sendTextMessage("5551056594", null, "Javier" + " tiene una emergencia", null, null);
        }
        catch (SecurityException x )
        {
            Log.e("err",x.toString());
        }

    }

    public void makePhoneCall() {

    }

    public void sendWhats(Context context) // No funciona
    {
        Uri mUri = Uri.parse("smsto:2221091551");
        Intent mIntent = new Intent(Intent.ACTION_SENDTO, mUri);
        mIntent.setPackage("com.whatsapp");
        mIntent.putExtra("sms_body", "The text goes here");
        mIntent.putExtra("chat", true);
        context.startActivity(mIntent);
    }

    private void savePreferences(String key, String value) {
        SharedPreferences sharedPreferences = context.getSharedPreferences("prefs_file", 0);
        SharedPreferences.Editor editor = sharedPreferences.edit();
        editor.putString(key, value);
        editor.commit();
    }

    private String loadPreferences(String key) {
        SharedPreferences sharedPreferences = context.getSharedPreferences("prefs_file", 0);
        return sharedPreferences.getString(key, "");
    }

    public void startTimer() {
        //set a new Timer
        timer = new Timer();
        //initialize the TimerTask's job
        //initializeTimerTask();
        //schedule the timer, after the first 5000ms the TimerTask will run every 10000ms
        timer.schedule(timerTask, 1000, 1000); //
    }

    public void stoptimertask() {      //stop the timer, if it's not already null
        //
        if (timer != null) {
            timer.cancel();
            timer = null;
        }
    }

    /*public void initializeTimerTask() {
        timerTask = new TimerTask() {
            public void run() {//use a handler to run a toast that shows the current timestamp
                handler.post(new Runnable() {
                    public void run() {//get the current timeStamp
                        cont++;
                        if (cont >= 5) {
                            sendSMS();
                            stoptimertask();
                            int duration = Toast.LENGTH_SHORT;
                            //SEND TO DB
                            Toast toast = Toast.makeText(context, "Alarma Enviada!!!", duration);
                            toast.show();
                            listener.onTaskCompleted();

                        }
                    }
                });
            }
        };
    }*/


}
