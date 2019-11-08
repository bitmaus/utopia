package com.treeop.datetime;

import android.content.Intent;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.view.View;
import android.widget.LinearLayout;
import android.widget.TextView;

public class DisplayMessageActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);



        // add the textview to the linearlayout
        //myLinearLayout.addView(rowTextView);
        setContentView(R.layout.activity_display_message);

        // Get the Intent that started this activity and extract the string
        Intent intent = getIntent();
        String message = intent.getStringExtra(MainActivity2.EXTRA_MESSAGE);

        // Capture the layout's TextView and set the string as its text

        TextView textView = (TextView)findViewById(R.id.textView2);
        textView.setText(message);

        final TextView rowTextView = new TextView(this);
        LinearLayout myLinearLayout = (LinearLayout)findViewById(R.id.linearLayout);
        // set some properties of rowTextView or something
        rowTextView.setText("This is row #");

        myLinearLayout.addView(rowTextView);
    }

    public void sendMessage(View view) {
        final TextView rowTextView = new TextView(this);
        LinearLayout myLinearLayout = (LinearLayout)findViewById(R.id.linearLayout);
        // set some properties of rowTextView or something
        rowTextView.setText("Get item");

        myLinearLayout.addView(rowTextView);
    }
}
