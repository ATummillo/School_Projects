package edu.pitt.cs.cs1635.ant72.assignment2_scribbler;

import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.Spinner;
import android.content.Intent;

public class OptionsActivity extends AppCompatActivity {
    private Spinner paint_spinner;
    Button options_button;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_options);

        paint_spinner = (Spinner) findViewById(R.id.paint_spinner);
        options_button = (Button)findViewById(R.id.options_button);

        options_button.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                set_options(view);
            }
        });
    }

    private void set_options(View view){
        Intent output = new Intent();
        output.putExtra("paint_color", paint_spinner.getSelectedItem().toString());
        setResult(RESULT_OK, output);
        finish();
    }
}
