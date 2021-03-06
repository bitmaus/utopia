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


package com.treeop.datetime;

import android.animation.AnimatorSet;
import android.animation.ObjectAnimator;
import android.app.Activity;
import android.content.ClipData;
import android.content.Intent;
import android.graphics.drawable.Drawable;
import android.os.Bundle;
import android.view.DragEvent;
import android.view.MotionEvent;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.view.animation.Animation;
import android.view.animation.AnimationUtils;
import android.view.animation.RotateAnimation;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

public class MainActivity2 extends Activity implements OnClickListener, Animation.AnimationListener {

    public static final String EXTRA_MESSAGE = "com.example.myfirstapp.MESSAGE";
    private final boolean IN = true;
    private boolean state = IN;

    private Animation animation1;
    private Animation animation2;
    private boolean isBackOfCardShowing = true;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main2);

        findViewById(R.id.button).setOnClickListener(this);
        animation1 = AnimationUtils.loadAnimation(this, R.anim.to_middle);
        animation1.setAnimationListener(this);
        animation2 = AnimationUtils.loadAnimation(this, R.anim.from_middle);
        animation2.setAnimationListener(this);

        findViewById(R.id.image_view).setOnTouchListener(new MyTouchListener());
        findViewById(R.id.my_image).setOnTouchListener(new MyTouchListener());
        findViewById(R.id.top_left).setOnDragListener(new MyDragListener());

        findViewById(R.id.myimage2).setOnTouchListener(new MyTouchListener());
        findViewById(R.id.topright).setOnDragListener(new MyDragListener());
    }
    @Override
    public void onClick(View v) {
        ((ImageView)findViewById(R.id.image_view)).clearAnimation();
        ((ImageView)findViewById(R.id.image_view)).setAnimation(animation1);
        ((ImageView)findViewById(R.id.image_view)).startAnimation(animation1);

        TextView tv = (TextView)findViewById(R.id.text_view);
        tv.setText("Hello Transition!");

        ImageView iv = (ImageView)findViewById(R.id.image_view);

        RotateAnimation rotate = new RotateAnimation(180, 360, Animation.RELATIVE_TO_SELF,
                0.5f,  Animation.RELATIVE_TO_SELF, 0.5f);
        rotate.setDuration(500);
        //iv.startAnimation(rotate);
        ObjectAnimator scaleXOut = ObjectAnimator.ofFloat(tv, "scaleX", 1f, 0f);
        ObjectAnimator scaleXIn = ObjectAnimator.ofFloat(tv, "scaleX", 0f, 1f);
        ObjectAnimator scaleYOut = ObjectAnimator.ofFloat(tv, "scaleY", 1f, 0f);
        ObjectAnimator scaleYIn = ObjectAnimator.ofFloat(tv, "scaleY", 0f, 1f);
        ObjectAnimator rotateClockWise = ObjectAnimator.ofFloat(tv, "rotation", 0f, 360f);
        ObjectAnimator rotateCounterClockWise = ObjectAnimator.ofFloat(tv, "rotation", 0f, -360f);
        AnimatorSet set = new AnimatorSet();
        if (state == IN) {
            set.play(scaleXIn).with(rotateClockWise).with(scaleYIn);
        } else {
            set.play(scaleXOut).with(rotateCounterClockWise).with(scaleYOut);
        }
        state = !state;
        set.setDuration(1000);
        set.start();
    }
    public void sendMessage(View view) {
        // Do something in response to button
        Intent intent = new Intent(this, DisplayMessageActivity.class);
        EditText editText = (EditText) findViewById(R.id.editText);
        String message = editText.getText().toString();
        intent.putExtra(EXTRA_MESSAGE, message);
        startActivity(intent);
    }
    @Override
    public void onAnimationEnd(Animation animation) {
        if (animation==animation1) {
            if (isBackOfCardShowing) {
                ((ImageView)findViewById(R.id.image_view)).setImageResource(R.drawable.card_front2);
            } else {
                ((ImageView)findViewById(R.id.image_view)).setImageResource(R.drawable.card_back);
            }
            ((ImageView)findViewById(R.id.image_view)).clearAnimation();
            ((ImageView)findViewById(R.id.image_view)).setAnimation(animation2);
            ((ImageView)findViewById(R.id.image_view)).startAnimation(animation2);
            ImageView rotateImage = (ImageView) findViewById(R.id.image_view);
            Animation startRotateAnimation = AnimationUtils.loadAnimation(getApplicationContext(), R.anim.from_rotate);
            rotateImage.startAnimation(startRotateAnimation);
        } else {
            isBackOfCardShowing=!isBackOfCardShowing;
            //findViewById(R.id.button1).setEnabled(true);
        }
    }
    @Override
    public void onAnimationRepeat(Animation animation) {
        // TODO Auto-generated method stub
    }
    @Override
    public void onAnimationStart(Animation animation) {
        // TODO Auto-generated method stub
    }

    private final class MyTouchListener implements View.OnTouchListener {
        public boolean onTouch(View view, MotionEvent motionEvent) {
            if (motionEvent.getAction() == MotionEvent.ACTION_DOWN) {
                ClipData data = ClipData.newPlainText("", "");
                View.DragShadowBuilder shadowBuilder = new View.DragShadowBuilder(
                        view);
                view.startDrag(data, shadowBuilder, view, 0);
                view.setVisibility(View.INVISIBLE);
                return true;
            } else {
                return false;
            }
        }
    }

    class MyDragListener implements View.OnDragListener {
        Drawable enterShape = getResources().getDrawable(
                R.drawable.shape_droptarget);
        Drawable normalShape = getResources().getDrawable(R.drawable.shape);

        @Override
        public boolean onDrag(View v, DragEvent event) {
            int action = event.getAction();
            switch (event.getAction()) {
                case DragEvent.ACTION_DRAG_STARTED:
                    // do nothing
                    break;
                case DragEvent.ACTION_DRAG_ENTERED:
                    v.setBackgroundDrawable(enterShape);
                    break;
                case DragEvent.ACTION_DRAG_EXITED:
                    v.setBackgroundDrawable(normalShape);
                    break;
                case DragEvent.ACTION_DROP:
                    // Dropped, reassign View to ViewGroup
                    View view = (View) event.getLocalState();
                    ViewGroup owner = (ViewGroup) view.getParent();
                    owner.removeView(view);
                    LinearLayout container = (LinearLayout) v;
                    container.addView(view);
                    view.setVisibility(View.VISIBLE);
                    break;
                case DragEvent.ACTION_DRAG_ENDED:
                    v.setBackgroundDrawable(normalShape);
                default:
                    break;
            }
            return true;
        }
    }
}


package service;

import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.support.design.widget.FloatingActionButton;
import android.support.design.widget.Snackbar;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.view.View;
import android.view.Menu;
import android.view.MenuItem;
import android.widget.TextView;

import com.android.volley.RequestQueue;
import com.android.volley.toolbox.Volley;
import com.treeop.datetime.R;


public class MainActivity extends AppCompatActivity {
    RequestQueue queue;
    Context con = this;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        ////Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
        ////setSupportActionBar(toolbar);

        FloatingActionButton fab = (FloatingActionButton) findViewById(R.id.fab);
        fab.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {


                Requestor req = new Requestor();
                ////req.setText((TextView) findViewById(R.id.resultBox));
                queue = Volley.newRequestQueue(con);
                //req.sendRequest(queue, (TextView) findViewById(R.id.resultBox));

                Post temp = new Post();
                ////temp.execute((TextView)findViewById(R.id.resultBox));

                Snackbar.make(view, "Replace with your own action", Snackbar.LENGTH_LONG)
                        .setAction("Action", null).show();

                Intent intent = new Intent(con, Web.class);
                //startActivity(intent);

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


}
