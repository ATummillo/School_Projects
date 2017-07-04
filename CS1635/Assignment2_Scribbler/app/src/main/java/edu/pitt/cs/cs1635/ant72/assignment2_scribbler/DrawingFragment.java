package edu.pitt.cs.cs1635.ant72.assignment2_scribbler;

import android.support.v4.app.Fragment;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.graphics.*;
import android.util.AttributeSet;
import android.content.Context;


public class DrawingFragment extends Fragment{
    public void onCreate(Bundle savedInstanceState){
        super.onCreate(savedInstanceState);
    }

    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState){
        final View v = inflater.inflate(R.layout.drawing_fragment, container, false);
        return v;
    }

    public static class DrawingView extends View{
        private Paint paint = new Paint();
        private Path path = new Path();

        public DrawingView(Context context, AttributeSet attr){
            super(context, attr);
            paint.setAntiAlias(true);
            paint.setStrokeWidth(4);
            paint.setStyle(Paint.Style.STROKE);
            paint.setStrokeJoin(Paint.Join.ROUND);
        }

        protected void onDraw(Canvas canvas){
            //paint.setColor(Singleton.getInstance().getColor());
            canvas.drawPath(path,paint);
        }

        public boolean onTouchEvent(MotionEvent event) {
            float eventX = event.getX();
            float eventY = event.getY();
            paint.setColor(Singleton.getInstance().getColor());
            switch(event.getAction()){
                case MotionEvent.ACTION_DOWN:
                    path.moveTo(eventX, eventY);
                    return true;
                case MotionEvent.ACTION_MOVE:
                    path.lineTo(eventX, eventY);
                    break;
                default:
                    return false;
            }
            invalidate();
            return true;
        }
    }

}
