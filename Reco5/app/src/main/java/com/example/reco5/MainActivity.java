package com.example.reco5;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;

import android.Manifest;
import android.content.pm.PackageManager;
import android.media.AudioAttributes;
import android.media.AudioManager;
import android.media.MediaPlayer;
import android.media.MediaRecorder;
import android.media.SoundPool;
import android.os.Build;
import android.os.Bundle;
import android.os.Environment;
import android.view.View;
import android.widget.Button;
import android.widget.Toast;

import java.io.IOException;
import java.util.UUID;

public class MainActivity extends AppCompatActivity {
    // soundboard
    private SoundPool soundpool;
    private int sound1, sound2, sound3, sound4;

    // recorder
    Button btn_startRec, btn_stopRec, btn_startAud, btn_stopAud;
    String pathSave = "";
    MediaRecorder mediaRecorder;
    MediaPlayer mediaPlayer;

    final int REQUEST_PERMISSION_CODE = 1000;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        // soundboard
        if(Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP){
            AudioAttributes audioAttributes = new AudioAttributes.Builder()
                    .setUsage(AudioAttributes.USAGE_ASSISTANCE_SONIFICATION)
                    .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                    .build();
            soundpool = new SoundPool.Builder()
                    .setMaxStreams(4)
                    .setAudioAttributes(audioAttributes)
                    .build();
        }
        else {
            soundpool = new SoundPool(4, AudioManager.STREAM_MUSIC, 0);
        }
        sound1 = soundpool.load(this, R.raw.yay, 1);
        sound2 = soundpool.load(this, R.raw.boo, 1);
        sound3 = soundpool.load(this, R.raw.laugh, 1);
        //sound4 = soundpool.load(this, R.raw.aha, 1);

        // recorder & playback
        if(!checkPermissionFromDevice()){
            requestPermissions();
        }

        btn_startAud = (Button) findViewById(R.id.btn_startAud);
        btn_stopAud = (Button) findViewById(R.id.btn_stopAud);
        btn_startRec = (Button) findViewById(R.id.btn_startRec);
        btn_stopRec = (Button) findViewById(R.id.btn_stopRec);


        btn_startRec.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                if (checkPermissionFromDevice()) {

                    pathSave = Environment.getExternalStorageDirectory().getAbsolutePath() + "/"
                            + UUID.randomUUID().toString() + "_audio_record.3gp";
                    setupMediaRecorder();
                    try {
                        mediaRecorder.prepare();
                        mediaRecorder.start();
//                        btn_stopRec.setEnabled(true);
//                        btn_startAud.setEnabled(false);
//                        btn_startRec.setEnabled(false);
//                        btn_stopAud.setEnabled(false);
                    } catch (IOException e) {
                        e.printStackTrace();
                    }
                    btn_startAud.setEnabled(false);
                    btn_stopAud.setEnabled(false);

                    Toast.makeText(MainActivity.this, "Now Recording...", Toast.LENGTH_SHORT).show();
                }
                else{
                    requestPermissions();
                }
            }
        });
        btn_stopRec.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                mediaRecorder.stop();
                btn_stopRec.setEnabled(false);
                btn_startAud.setEnabled(true);
                btn_startRec.setEnabled(true);
                btn_stopAud.setEnabled(false);
            }
        });
        btn_startAud.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                btn_stopAud.setEnabled(true);
                btn_stopRec.setEnabled(false);
                btn_startRec.setEnabled(false);

                mediaPlayer = new MediaPlayer();
                try {
                    mediaPlayer.setDataSource(pathSave);
                    mediaPlayer.prepare();
                }
                catch (IOException e) {
                    e.printStackTrace();
                }
                mediaPlayer.start();
                Toast.makeText(MainActivity.this, "Now Playing...", Toast.LENGTH_SHORT).show();
            }
        });
        btn_stopAud.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                btn_stopRec.setEnabled(false);
                btn_startRec.setEnabled(true);
                btn_stopAud.setEnabled(false);
                btn_startAud.setEnabled(true);

                if (mediaPlayer != null) {
                    mediaPlayer.stop();
                    mediaPlayer.release();
                    setupMediaRecorder();
                }
            }
        });
    }

    private void setupMediaRecorder() {
        mediaRecorder = new MediaRecorder();
        mediaRecorder.setAudioSource(MediaRecorder.AudioSource.MIC);
        mediaRecorder.setOutputFormat(MediaRecorder.OutputFormat.THREE_GPP);
        mediaRecorder.setAudioEncoder(MediaRecorder.OutputFormat.AMR_NB);
        mediaRecorder.setOutputFile(pathSave);
    }

    private void requestPermissions() {
        ActivityCompat.requestPermissions(this, new String[]{
                Manifest.permission.WRITE_EXTERNAL_STORAGE,
                Manifest.permission.RECORD_AUDIO
        }, REQUEST_PERMISSION_CODE);
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
        switch (requestCode) {
            case REQUEST_PERMISSION_CODE: {
                if (grantResults.length > 0 && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                    Toast.makeText(this, "Permission Granted", Toast.LENGTH_SHORT).show();
                }
                else {
                    Toast.makeText(this, "Permission Denied", Toast.LENGTH_SHORT).show();
                }
            }
            break;
        }
    }

    private boolean checkPermissionFromDevice() {
        int write_external_storage_result = ContextCompat.checkSelfPermission(this, Manifest.permission.WRITE_EXTERNAL_STORAGE);
        int record_audio_result = ContextCompat.checkSelfPermission(this, Manifest.permission.RECORD_AUDIO);
        return write_external_storage_result == PackageManager.PERMISSION_GRANTED &&
                record_audio_result == PackageManager.PERMISSION_GRANTED;
    }

    // soundboard sounds
    public void playSound(View v) {
        switch (v.getId()) {
            case R.id.btn_sound1:
                soundpool.play(sound1, 1, 1, 0, 0, 1);
                //soundpool.autoPause();
                break;
            case R.id.btn_sound2:
                soundpool.play(sound2, 1, 1, 0, 0, 1);
                break;
            case R.id.btn_sound3:
                soundpool.play(sound3, 1, 1, 0, 0, 1);
                break;
//            case R.id.btn_sound4:
//                soundpool.play(sound4, 1, 1, 0, 0, 1);
//                break;
        }
    }
    @Override
    protected void onDestroy(){
        super.onDestroy();
        soundpool.release();
        soundpool = null;
    }
}

