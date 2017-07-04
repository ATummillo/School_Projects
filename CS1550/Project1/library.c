/*
	Anthony Tummillo
	CS1550 Project 1
	Professor Misurda
*/
#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <sys/ioctl.h>
#include <sys/mman.h>
#include <linux/fb.h>
#include <time.h>
#include <termios.h>
#include "iso_font.h"

int filedesc = 0;
typedef unsigned short color_t;
color_t * screen_map = 0;
struct termios settings;
int size;
		
void init_graphics(){
	struct fb_var_screeninfo vinfo;
	struct fb_fix_screeninfo finfo;
	
	filedesc = open("/dev/fb0", O_RDWR);
	
	ioctl(filedesc, FBIOGET_FSCREENINFO, &finfo);
	ioctl(filedesc, FBIOGET_VSCREENINFO, &vinfo);
	
	size = vinfo.yres_virtual*finfo.line_length;
	
	screen_map = (color_t *)mmap(NULL, 
	(size), PROT_READ | PROT_WRITE, 
	MAP_SHARED, filedesc, 0);
	
	ioctl(1, TCGETS, &settings);
	
	settings.c_lflag = settings.c_lflag & ~(ICANON | ECHO);
	
	ioctl(1, TCSETS, &settings);
}

color_t make_color(color_t red, color_t green, color_t blue){
	color_t color_red = red<<11;
	color_t color_green = green<<5;
	color_t res = (color_red | color_green | blue);
	return res;
}

void sleep_ms(long ms){

	struct timespec sleep_time;
	sleep_time.tv_sec = 0;
	sleep_time.tv_nsec = ms * 1000000;
	
	nanosleep(&sleep_time, NULL);
	
}

void clear_screen(){

	write(1, "\033[2J", 6);
	
}

void exit_graphics(){
	
	munmap(screen_map, size);
	close(filedesc);
	settings.c_lflag = settings.c_lflag | (ECHO | ICANON);
	int i = ioctl(1, TCSETS, &settings);
}

char getkey(){
	
	fd_set rfds;
	int retval;
	char c;
	
	FD_ZERO(&rfds);
	FD_SET(0, &rfds);
	
	retval = select(1, &rfds, NULL, NULL, NULL);
	
	if(retval){
		read(0, &c, 1);
	}else{
		c = ' ';
	}
	
	return c;
}

void draw_pixel(int x, int y, color_t color){
	screen_map[(640*y)+x] = color;
}

void draw_rect(int x1, int y1, int width, int height, color_t c){

	int i;
	int j;

	for(i = 0; i < width; i++){
		draw_pixel((x1+i), y1, c);
		draw_pixel((x1+i), (y1+height), c);
	}
	
	for(j = 0; j < height; j++){
		draw_pixel(x1, (y1+j), c);
		draw_pixel((x1+width), (y1+j), c);
	}
	draw_pixel((x1+width), (y1+height), c);
}

void draw_text(int x, int y, const char *text, color_t c){
	int original_x = x;
	
	do{
		draw_char(x, y, *(text), c);
		x = x+8;
		if((x+8) >= 640){
			y = y+16;
			x = original_x;
		}
	}while(*(text++) != '\0');
}

void draw_char(int x, int y, char letter, color_t c){
	int i;
	int k;
	char info;
	char marker = 1;
	char check = 0;
	for(i = 0; i < 16; i++){
		info = iso_font[(letter*16)+i];
		for(k = 0; k < 8; k++){
			check = (info & marker);
			if(check){
				draw_pixel((x+k), (y+i), c);
			}
			info = info>>1;
		}
	}
}
