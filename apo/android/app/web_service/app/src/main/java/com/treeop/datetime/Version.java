package com.treeop.datetime;

import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;

import android.widget.TextView;

public class Version extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        int versionCode = BuildConfig.VERSION_CODE;
        String versionName = BuildConfig.VERSION_NAME;

        setContentView(R.layout.content_main);
        TextView versionStamp = (TextView) findViewById(R.id.stamp);

        versionStamp.setText(versionName);

    }
}
