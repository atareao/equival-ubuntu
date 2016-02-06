/* -*- Mode: vala; indent-tabs-mode: t; c-basic-offset: 4; tab-width: 4 -*-  */
/* equival
 *
 * Copyright (C) 2013 Lorenzo Carbonell <lorenzo.carbonell.cerezo@gmail.com>
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
using Json;

public class Equival : Dialog {
	private Configuration configuration;
	private SpecialEntry entry_magnitude;
	private SpecialEntry entry_unidad1;
	private SpecialEntry entry_unidad2;
	private Gtk.Entry entry_value1;
	private Gtk.Entry entry_value2;
	// Constructor
	public Equival () {
		this.set_position (Gtk.WindowPosition.CENTER_ALWAYS);
		this.set_title(Constants.NAME);
		var file = File.new_for_path(Comun.ICON_FILE);
		if(!file.query_exists()){
			file = File.new_for_path(GLib.Path.build_filename(Constants.PKGDATADIR,"icons",Comun.ICON_FILE));
			if(!file.query_exists()){
				Gtk.main_quit();
			}
		}
		try{		
			this.icon = new Gdk.Pixbuf.from_file(file.get_path());
		}catch(Error e){
		}
		this.set_default_size (650,120);
		this.destroy.connect(on_window_destroy);		
		Gtk.Box vbox1= new Box(Gtk.Orientation.VERTICAL,20);
		get_content_area().pack_start(vbox1,true,true,0);
		Gtk.MenuBar menubar = new Gtk.MenuBar();
		vbox1.add(menubar);
		Gtk.Menu menu = new Gtk.Menu();
		Gtk.MenuItem menu_item = new Gtk.MenuItem.with_label(_("Exit"));
		menu_item.activate.connect(on_window_destroy);
		menu.append(menu_item);
		Gtk.MenuItem filem = new Gtk.MenuItem.with_label(_("File"));
		filem.set_submenu(menu);
		menubar.append(filem);
		Gtk.MenuItem fileh = new Gtk.MenuItem.with_label(_("Help"));
		fileh.set_submenu(get_help_menu());
		menubar.append(fileh);		
		/*this.add(vbox1);*/
		Gtk.Grid grid = new Gtk.Grid();
		grid.column_spacing = 5;
		grid.row_spacing = 5;
		vbox1.add(grid);
		entry_magnitude = new SpecialEntry();
		entry_magnitude.selected_signal.connect(on_magnitud_selected);
		grid.attach(entry_magnitude,0,0,1,1);
		entry_magnitude.set_values(read_data ());
		entry_unidad1 = new SpecialEntry();
		entry_unidad1.selected_signal.connect(on_unidad1_selected);
		grid.attach(entry_unidad1,0,1,1,1);
		entry_unidad2 = new SpecialEntry();
		entry_unidad2.selected_signal.connect(on_unidad2_selected);
		grid.attach(entry_unidad2,0,2,1,1);
		entry_value1 = new Gtk.Entry();
		entry_value1.width_chars = 40;
		entry_value1.key_release_event.connect(on_value1_changed);
		grid.attach(entry_value1,1,1,1,1);
		entry_value2 = new Gtk.Entry();
		entry_value2.width_chars = 40;
		entry_value2.key_release_event.connect(on_value2_changed);
		grid.attach(entry_value2,1,2,1,1);
		entry_value1.text = "0.0";
		entry_value2.text = "0.0";
		//
		configuration = new Configuration();
		stdout.printf("e\n");
		stdout.printf(configuration.get_param("magnitud"));
		stdout.printf("\n");
		stdout.printf("========================================\n");
		stdout.printf(configuration.get_param("magnitud")+"\n");
		stdout.printf(configuration.get_param("unidad1")+"\n");
		stdout.printf(configuration.get_param("unidad2")+"\n");
		entry_magnitude.set_selected(configuration.get_param("magnitud"));
		on_magnitud_selected(entry_magnitude.get_selected_elemento());
		entry_unidad1.set_selected(configuration.get_param("unidad1"));
		entry_unidad2.set_selected(configuration.get_param("unidad2"));
	}
	private bool on_value1_changed(Gdk.EventKey event){
		return convert();
	}
	private bool on_value2_changed(Gdk.EventKey event){
		return inv_convert();
	}
	private void on_unidad1_selected(Elemento elemento){
		convert();
	}
	private void on_unidad2_selected(Elemento elemento){
		inv_convert();
	}
	private void on_magnitud_selected(Elemento elemento){
		stdout.printf("\nSELECTED SIGNAL\n");
		if(elemento!=null){
			stdout.printf(elemento.nombre+"\n");
			GLib.List<Elemento> list = new GLib.List<Elemento> ();
			foreach(string unidad_string in elemento.objeto.get_object_member("unidades").get_members()){
				Json.Object unidad_object = elemento.objeto.get_object_member("unidades").get_object_member(unidad_string);
				list.append(new Elemento.with_data(unidad_string,unidad_object));
			}
			entry_unidad1.set_values(list);
			entry_unidad2.set_values(list);
			convert();
		}
	}
	private void open_url(string url){
		try{
			Gtk.show_uri(null,url,0);
		}catch(Error e){
		}
	}
	private Gtk.Menu get_help_menu(){
		Gtk.Menu help_menu = new Gtk.Menu();	
		Gtk.MenuItem menu_item1 = new Gtk.MenuItem.with_label(_("Homepage")+"...");		
		menu_item1.activate.connect(() => open_url("https://launchpad.net/"+Constants.PACKAGE));
		help_menu.append(menu_item1);
		Gtk.MenuItem menu_item2 = new Gtk.MenuItem.with_label(_("Source code")+"...");		
		menu_item2.activate.connect(() => open_url("https://code.launchpad.net/"+Constants.PACKAGE));
		help_menu.append(menu_item2);
		Gtk.MenuItem menu_item3 = new Gtk.MenuItem.with_label(_("Report a bug")+"...");		
		menu_item3.activate.connect(() => open_url("https://bugs.launchpad.net/"+Constants.PACKAGE));
		help_menu.append(menu_item3);
		Gtk.MenuItem menu_item4 = new Gtk.MenuItem.with_label(_("Request a new feature")+"...");		
		menu_item4.activate.connect(() => open_url("https://blueprints.launchpad.net/"+Constants.PACKAGE));
		help_menu.append(menu_item4);
		Gtk.MenuItem menu_item5 = new Gtk.MenuItem.with_label(_("Translate this application")+"...");		
		menu_item5.activate.connect(() => open_url("https://translations.launchpad.net/"+Constants.PACKAGE));
		help_menu.append(menu_item5);
		Gtk.MenuItem menu_item6 = new Gtk.MenuItem.with_label(_("Get help online")+"...");		
		menu_item6.activate.connect(() => open_url("https://answers.launchpad.net/"+Constants.PACKAGE));
		help_menu.append(menu_item6);
		Gtk.SeparatorMenuItem menu_item7 = new Gtk.SeparatorMenuItem ();
		help_menu.append(menu_item7);
		Gtk.ImageMenuItem menu_item8 = new Gtk.ImageMenuItem.with_label(_("Homepage"));
		menu_item8.set_image(new Gtk.Image.from_file(GLib.Path.build_filename(Constants.PKGDATADIR,"icons","web.svg")));
		menu_item8. set_always_show_image(true);
		menu_item8.activate.connect(() => open_url("http://www.atareao.es"));
		help_menu.append(menu_item8);
		Gtk.ImageMenuItem menu_item9 = new Gtk.ImageMenuItem.with_label(_("Follow me on Twitter"));
		menu_item9.set_image(new Gtk.Image.from_file(GLib.Path.build_filename(Constants.PKGDATADIR,"icons","twitter.svg")));
		menu_item9. set_always_show_image(true);
		menu_item9.activate.connect(() => open_url("https://twitter.com/atareao"));
		help_menu.append(menu_item9);
		Gtk.ImageMenuItem menu_item10 = new Gtk.ImageMenuItem.with_label(_("Follow me on Google+"));
		menu_item10.set_image(new Gtk.Image.from_file(GLib.Path.build_filename(Constants.PKGDATADIR,"icons","googleplus.svg")));
		menu_item10. set_always_show_image(true);
		menu_item10.activate.connect(() => open_url("https://plus.google.com/118214486317320563625/posts"));
		help_menu.append(menu_item10);
		Gtk.ImageMenuItem menu_item11 = new Gtk.ImageMenuItem.with_label(_("Follow me on Facebook"));
		menu_item11.set_image(new Gtk.Image.from_file(GLib.Path.build_filename(Constants.PKGDATADIR,"icons","facebook.svg")));
		menu_item11. set_always_show_image(true);
		menu_item11.activate.connect(() => open_url("http://www.facebook.com/elatareao"));
		help_menu.append(menu_item11);
		Gtk.SeparatorMenuItem menu_item12 = new Gtk.SeparatorMenuItem ();
		help_menu.append(menu_item12);
		Gtk.MenuItem menu_item13 = new Gtk.MenuItem.with_label(_("About"));		
		menu_item13.activate.connect(() => {
			Gtk.AboutDialog ad= new Gtk.AboutDialog();
			ad.set_destroy_with_parent(true);
			ad.set_modal(true);
			ad.set_name(Constants.NAME);
			ad.set_version(Constants.VERSION);
			ad.set_copyright(Constants.COPYRIGHT);
			ad.set_comments(Constants.COMMENT);
			ad.set_license("This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.\n\nThis program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.\n\nYou should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.");
			ad.wrap_license = true;
			ad.set_website("https://launchpad.net/"+Constants.PACKAGE);
			ad.set_website_label("https://launchpad.net/"+Constants.PACKAGE);
			ad.authors={Constants.AUTHOR};
			ad.documenters={Constants.AUTHOR};
			ad.translator_credits=Constants.AUTHOR;
			ad.set_program_name(Constants.NAME);
			try{
				ad.logo = new Gdk.Pixbuf.from_file(GLib.Path.build_filename(Constants.PKGDATADIR,"icons",Comun.ICON_FILE));
			}catch(Error e){
			}
			ad.response.connect ((response_id) => {
				if (response_id == Gtk.ResponseType.CANCEL || response_id == Gtk.ResponseType.DELETE_EVENT) {
					ad.hide_on_delete();
				}
			});
			ad.present();
		});
		help_menu.append(menu_item13);
		return help_menu;
	}
	private GLib.List<Elemento> read_data(){
		GLib.List<Elemento> list = new GLib.List<Elemento> ();	
		Json.Parser parser = new Json.Parser();
		var file = File.new_for_path(Comun.DATA_FILE);
		if(!file.query_exists()){
			file = File.new_for_path(GLib.Path.build_filename(Constants.PKGDATADIR,Comun.DATA_FILE));
			if(!file.query_exists()){
				Gtk.main_quit();
			}
		}try{
			if(parser.load_from_file(file.get_path())){
				Json.Node root = parser.get_root();
				stdout.printf(root.get_object().get_object_member("magnitudes").get_members().length().to_string());
				foreach(string magnitud_string in root.get_object().get_object_member("magnitudes").get_members()){
					Json.Object magnitud_object = root.get_object().get_object_member("magnitudes").get_object_member(magnitud_string);
					list.append(new Elemento.with_data(magnitud_string,magnitud_object));
				}
			}
		}catch(Error e){
		}
		return list;
	}
	public void on_window_destroy(){
		configuration.set_param("magnitud",entry_magnitude.get_selected());
		configuration.set_param("unidad1",entry_unidad1.get_selected());
		configuration.set_param("unidad2",entry_unidad2.get_selected());
		configuration.save();
		Gtk.main_quit();
	}
	private bool convert(){
		Elemento elemento1 = entry_unidad1.get_selected_elemento();
		Elemento elemento2 = entry_unidad2.get_selected_elemento();
		if(elemento1!=null&&elemento2!=null){
			double factor1 = elemento1.objeto.get_double_member("factor");		
			double factor2 = elemento2.objeto.get_double_member("factor");
			double value2 = double.parse(entry_value1.text)*factor1/factor2;
			entry_value2.text = value2.to_str(new char[double.DTOSTR_BUF_SIZE]);
			return true;
		}
		return false;
	}
	private bool inv_convert(){
		Elemento elemento1 = entry_unidad1.get_selected_elemento();
		Elemento elemento2 = entry_unidad2.get_selected_elemento();
		if(elemento1!=null&&elemento2!=null){
			double factor1 = elemento1.objeto.get_double_member("factor");		
			double factor2 = elemento2.objeto.get_double_member("factor");
			double value1 = double.parse(entry_value2.text)*factor2/factor1;
			entry_value1.text = value1.to_str(new char[double.DTOSTR_BUF_SIZE]);
			return true;
		}
		return false;
	}

}
