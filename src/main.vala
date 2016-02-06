/* -*- Mode: vala; indent-tabs-mode: t; c-basic-offset: 4; tab-width: 4 -*-  */
/* equival
 *
 * Copyright (C) 2013 atareao <atareao@ubuntu-raring>
 *
 * equival is free software: you can redistribute it and/or modify it
 * under the terms of the GNU General Public License as published by the
 * Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * equival is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
 * See the GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License along
 * with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
using Gtk;

public class Main{
	public static int main(string[] args){
		Gtk.init (ref args);
		Equival equival = new Equival();
		equival.destroy.connect(Gtk.main_quit);
		equival.show_all ();		
		
		Gtk.main();
		return 0;
	}
}

