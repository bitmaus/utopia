package com.treeop.datetime;


import android.support.v4.app.DialogFragment;
import android.support.v7.app.AlertDialog;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.View;
import android.widget.DatePicker;
import android.widget.TextView;
import android.widget.TimePicker;

import java.text.DateFormatSymbols;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.TimeZone;

public class DateTime extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_date_time);

        Date currentTime = Calendar.getInstance().getTime();
        Calendar currentDateTime = Calendar.getInstance();
        int cDay = currentDateTime.get(Calendar.DAY_OF_MONTH);
        int cMonth = currentDateTime.get(Calendar.MONTH) + 1;
        int cYear = currentDateTime.get(Calendar.YEAR);

        int cHour = currentDateTime.get(Calendar.HOUR);
        int cHour2 = currentDateTime.get(Calendar.HOUR_OF_DAY);
        int cMinute = currentDateTime.get(Calendar.MINUTE);
        int cSecond = currentDateTime.get(Calendar.SECOND);

        int cWeek = currentDateTime.get(Calendar.DAY_OF_WEEK);
        String weekday = new DateFormatSymbols().getShortWeekdays()[cWeek];

        String monthName = new DateFormatSymbols().getShortMonths()[cMonth - 1];

        String mobileTimeZone =  currentDateTime.getTimeZone()
                .getDisplayName(true, TimeZone.SHORT);


        TextView editText = (TextView) findViewById(R.id.textView);

        TextView editText2 = (TextView) findViewById(R.id.textView2);

        editText2.setText(cYear + " - " + cMonth + " (" + monthName +") - " + cDay + " (" + weekday + ") @ " + cHour2 + ":" + cMinute + " " + mobileTimeZone);

        editText.setText(currentTime.toString());

        Date date = new Date();
        LocalDate localDate = date.toInstant().atZone(ZoneId.systemDefault()).toLocalDate();
        LocalDateTime localDate2 = date.toInstant().atZone(ZoneId.systemDefault()).toLocalDateTime();
        int year  = localDate.getYear();
        int month = localDate.getMonthValue();

        int day   = localDate.getDayOfMonth();

        year = localDate2.getYear();
        month = localDate2.getMonthValue();
        day = localDate2.getDayOfMonth();

        String week = localDate2.getDayOfWeek().toString().substring(0, 1) + localDate2.getDayOfWeek().toString().substring(1, 2).toLowerCase();

        int hour = localDate2.getHour();
        int minute = localDate2.getMinute();




        //editText2.setText(year + "." + month + "." + day + " (" + week + ") @ " + hour + ":" + minute + " " + mobileTimeZone);
    }

    void showTime(View v) {
        DialogFragment newFragment = new TimePickerFragment();
        newFragment.show(getSupportFragmentManager(), "timePicker");
    }

    public void showDatePickerDialog(View v) {
        DialogFragment newFragment = new DatePickerFragment();
        newFragment.show(getSupportFragmentManager(), "datePicker");
    }

    public void showDateTime(View v) {
        //new AlertDialog.Builder(this).create();
        final View dialogView = View.inflate(this, R.layout.date_time_picker, null);
        final AlertDialog alertDialog = new AlertDialog.Builder(this).create();

        //RelativeLayout item = (RelativeLayout)findViewById(R.id.);
        //View child = getLayoutInflater().inflate(R.layout.child, null);
        //item.addView(child);

        dialogView.findViewById(R.id.date_time_set).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {

                DatePicker datePicker = (DatePicker) dialogView.findViewById(R.id.date_picker);
                TimePicker timePicker = (TimePicker) dialogView.findViewById(R.id.time_picker);

                Calendar calendar = new GregorianCalendar(datePicker.getYear(),
                        datePicker.getMonth(),
                        datePicker.getDayOfMonth(),
                        timePicker.getCurrentHour(),
                        timePicker.getCurrentMinute());

                //time = calendar.getTimeInMillis();
                alertDialog.dismiss();
            }
        });
        alertDialog.setView(dialogView);
        alertDialog.show();
    }
}

