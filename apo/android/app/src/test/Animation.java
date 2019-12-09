package com.treeop.datetime;

import android.graphics.drawable.AnimatedVectorDrawable;
import android.graphics.drawable.AnimationDrawable;
import android.graphics.drawable.Drawable;
import android.os.Bundle;
import android.support.graphics.drawable.AnimatedVectorDrawableCompat;
import android.support.v7.app.AppCompatActivity;
import android.view.View;
import android.widget.Button;
import android.widget.ImageView;

public class HeartRateActivity extends AppCompatActivity {
    @Override
    protected void onCreate(Bundle savedInstanceState){
        //setContentView(R.layout.main);

        super.onCreate(savedInstanceState);
        setContentView(R.layout.animation);

        Button butt = (Button) findViewById(R.id.button4);
        butt.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                animate((View) findViewById(R.id.imageView), (View) findViewById(R.id.imageView2));
            }
        });
    }

    public void animate(View view, View view2) {
        ImageView v = (ImageView) view;
        Drawable d = v.getDrawable();
        if (d instanceof AnimatedVectorDrawable) {
            AnimatedVectorDrawable avd = (AnimatedVectorDrawable) d;
            avd.start();
        } else if (d instanceof AnimatedVectorDrawableCompat) {
            AnimatedVectorDrawableCompat avd = (AnimatedVectorDrawableCompat) d;
            avd.start();
        }

        ImageView v2 = (ImageView) view2;
        v2.setImageResource(R.drawable.explosion);
        AnimationDrawable explosionAnimation = (AnimationDrawable)v2.getDrawable();
        explosionAnimation.start();
    }
}
