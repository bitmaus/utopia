package com.treeop.datetime;


import android.content.Intent;
import android.os.Bundle;
import android.support.design.widget.FloatingActionButton;
import android.support.design.widget.Snackbar;
import android.support.v7.app.AppCompatActivity;
import android.view.View;
import android.view.Menu;
import android.view.MenuItem;

import java.util.Timer;
import java.util.TimerTask;

import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.TextView;

import java.util.ArrayList;
import java.util.List;

import android.widget.ArrayAdapter;
import android.widget.Spinner;
import android.widget.Toast;


public class MainActivity extends AppCompatActivity {

    int versionCode = BuildConfig.VERSION_CODE;
    String versionName = BuildConfig.VERSION_NAME;

        private Spinner spinner1, spinner2;
        private Button btnSubmit;

        // add items into spinner dynamically
        public void addItemsOnSpinner2() {

            spinner2 = (Spinner) findViewById(R.id.spinner2);
            List<String> list = new ArrayList<String>();
            list.add("list a1");
            list.add("list a2");
            list.add("list a3");
            ArrayAdapter<String> dataAdapter = new ArrayAdapter<String>(this,
                    android.R.layout.simple_spinner_item, list);
            dataAdapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
            spinner2.setAdapter(dataAdapter);
        }

        public void addListenerOnSpinnerItemSelection() {
            spinner1 = (Spinner) findViewById(R.id.spinner1);
            spinner1.setOnItemSelectedListener(new CustomOnItemSelectedListener());
        }

        // get the selected dropdown list value
        public void addListenerOnButton() {

            spinner1 = (Spinner) findViewById(R.id.spinner1);
            spinner2 = (Spinner) findViewById(R.id.spinner2);
            btnSubmit = (Button) findViewById(R.id.btnSubmit);

            btnSubmit.setOnClickListener(new OnClickListener() {

                @Override
                public void onClick(View v) {

                    if (String.valueOf(spinner1.getSelectedItem()) == "a1 minute")
                        time = 60;
                    else
                        time = 10;

                    Toast.makeText(MainActivity.this,
                            "OnClickListener : " +
                                    "\nSpinner a1 : "+ String.valueOf(spinner1.getSelectedItem()) +
                                    "\nSpinner a2 : "+ String.valueOf(spinner2.getSelectedItem()),
                            Toast.LENGTH_SHORT).show();
                }

            });
        }







    int time = 20;
    Timer t;
    TimerTask task;
    Button start;

    public void startTimer(){
        t = new Timer();
        task = new TimerTask() {

            @Override
            public void run() {
                runOnUiThread(new Runnable() {

                    @Override
                    public void run() {
                        TextView tv1 = (TextView) findViewById(R.id.timer);
                        tv1.setText(time + "");
                        if (time > 0)
                            time -= 1;
                        else {
                            tv1.setText("Welcome");
                        }
                    }
                });
            }
        };
        t.scheduleAtFixedRate(task, 0, 1000);
    }




    @Override
    protected void onCreate(Bundle savedInstanceState) {
        //setContentView(R.layout.main);

        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        TextView versionStamp = (TextView) findViewById(R.id.stamp);

        versionStamp.setText(versionName);
        //Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
        //setSupportActionBar(toolbar);
        addItemsOnSpinner2();
        addListenerOnButton();
        addListenerOnSpinnerItemSelection();

        FloatingActionButton fab = (FloatingActionButton) findViewById(R.id.fab);
        fab.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Snackbar.make(view, "Replace with your own action", Snackbar.LENGTH_LONG)
                        .setAction("Action", null).show();
            }
        });

        Button butt = (Button) findViewById(R.id.button3);
        butt.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                showTime();
            }
        });

        start = (Button) findViewById(R.id.start);

        start.setOnClickListener(new OnClickListener() {

            @Override
            public void onClick(View v) {
                // TODO Auto-generated method stub
                if (start.getText().toString().equals("START")) {
                    start.setText("STOP");
                    time = 20;
                    startTimer();

                }else{
                    //t.cancel();
                    //t.purge();
                    TextView tv1 = (TextView) findViewById(R.id.timer);
                    tv1.setText("20");
                    start.setText("START");
                }
            }
        });
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu_main, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        int id = item.getItemId();

        //noinspection SimplifiableIfStatement
        if (id == R.id.action_settings) {
            return true;
        }

        return super.onOptionsItemSelected(item);
    }

    public void showTime() {
        Intent intent = new Intent(this, DateTime.class);
        //EditText editText = (EditText) findViewById(R.id.editText);
        //String message = editText.getText().toString();
        //intent.putExtra("new message", message);
        startActivity(intent);
    }
}
