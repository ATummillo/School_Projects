package edu.pitt.cs.cs1635.ant72.assignment2_scribbler;

import android.content.Intent;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentActivity;
import android.support.v4.app.FragmentManager;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.util.Log;
import android.graphics.Color;

public class MainActivity extends FragmentActivity {
    private Fragment fragment;
    private FragmentManager fm;
    static final int SELECT_OPTIONS_REQUEST = 1;

    Button clear_button;
    Button options_button;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        fm = getSupportFragmentManager();
        fragment = new DrawingFragment();

        int commit = fm.beginTransaction()
                .add(R.id.fragment_container, fragment)
                .commit();

        clear_button = (Button)findViewById(R.id.clear_button);
        options_button = (Button)findViewById(R.id.options_button);

        clear_button.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                clearView(view);
            }
        });

        options_button.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                set_options(view);
            }
        });


    }

    public void clearView(View view){
        fragment = new DrawingFragment();
        int commit = fm.beginTransaction()
                .add(R.id.fragment_container, fragment)
                .commit();
    }

    public void set_options(View view){
        Intent i = new Intent(MainActivity.this, OptionsActivity.class);
        startActivityForResult(i, SELECT_OPTIONS_REQUEST);
    }

    protected void onActivityResult(int requestCode, int resultCode, Intent data){
        if(requestCode == SELECT_OPTIONS_REQUEST){
            if(resultCode == RESULT_OK){
                String p_color = data.getStringExtra("paint_color");
                Log.d("myTag", p_color);

                switch(p_color){
                    case "Black":
                        Singleton.getInstance().setColor(Color.BLACK);
                        break;
                    case "Red":
                        Singleton.getInstance().setColor(Color.RED);
                        break;
                    case "Green":
                        Singleton.getInstance().setColor(Color.GREEN);
                        break;
                    case "Blue":
                        Singleton.getInstance().setColor(Color.BLUE);
                        break;
                }
            }
        }
    }
}
