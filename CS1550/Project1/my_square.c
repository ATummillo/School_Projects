/*
	I customized the sample driver so that it contained more
	functionality, and used every method from library.c 
*/
typedef unsigned short color_t;

void clear_screen();
void exit_graphics();
void init_graphics();
char getkey();
void sleep_ms(long ms);
color_t make_color(color_t red, color_t green, color_t blue);
void draw_rect(int x1, int y1, int width, int height, color_t c);
void draw_text(int x, int y, const char *text, color_t c);


int main(int argc, char** argv)
{
	int i;
	clear_screen();
	init_graphics();

	char key;
	int x = (640-20)/2;
	int y = (480-20)/2;

	do
	{
		draw_text(15, 15, "Use the w, s, a, and d keys to move the square around! Press q to quit", make_color(31, 10, 31));
		//draw a black rectangle to erase the old one
		draw_rect(x, y, 20, 20, 0);

		key = getkey();
		if(key == 'w') y-=10;
		else if(key == 's') y+=10;
		else if(key == 'a') x-=10;
		else if(key == 'd') x+=10;

		//draw a red rectangle
		draw_rect(x, y, 20, 20, make_color(31, 0, 0));
		sleep_ms(250);
	} while(key != 'q');
	//Cover up old text by drawing in black
	draw_text(15, 15, "Use the w, s, a, and d keys to move the square around! Press q to quit", make_color(0, 0, 0));
	//Cover up the old square by drawing a black one
	draw_rect(x, y, 20, 20, make_color(0, 0, 0));
	exit_graphics();

	return 0;

}
