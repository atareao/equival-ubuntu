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
struct MS{
	string name;
	Gtk.TreeIter iter;
}
public class SpecialEntry : Gtk.Entry {
	public signal void selected_signal(Elemento elemento);
	private Gtk.ListStore list_store;
	private Gtk.TreeIter selected_iter;
	// Constructor
	public SpecialEntry () {
		list_store = new Gtk.ListStore (2, typeof (string), typeof (Elemento));
		text = "";
		width_chars = 40;
		primary_icon_name = "edit-find-symbolic";
		secondary_icon_name = "edit-clear-symbolic";
		primary_icon_tooltip_text = "Search magnitud";
		secondary_icon_tooltip_text = "Clear magnitud";
		icon_press.connect(on_icon_press);
		focus_out_event.connect(on_lost_focus);
		Gtk.EntryCompletion completion= new Gtk.EntryCompletion();
		completion.minimum_key_length = 0;
		completion.popup_single_match = true;		
		completion.model = list_store;
		completion.text_column = 0;
		completion.match_selected.connect(on_match_selected);
		set_completion(completion);
	}
	private bool on_lost_focus(Gtk.Widget widget, Gdk.EventFocus event){
		if(text.length>0){
			GLib.List<MS?> names = get_names();
			string searchfor=text.casefold();
			foreach(MS name in names){
				if(name.name.length>=searchfor.length && searchfor==name.name[0:searchfor.length]){
					stdout.printf("eeeooo\n");
					stdout.printf(name.name+"\n");					
					set_selected_iter(name.iter);
					return true;
				}
			}
		}
		Gtk.TreeIter aiter;
		if(list_store.get_iter_first(out aiter)){
			set_selected_iter(aiter);
		}
		return true;
	}
	public Elemento? get_selected_elemento(){
		if(list_store.iter_is_valid(selected_iter)){
			return get_elemento(selected_iter);
		}
		return null;
	}
	public Elemento? get_elemento(Gtk.TreeIter aiter){
		GLib.Value ans;
		list_store.get_value(aiter,1,out ans);
		if(list_store.iter_is_valid(aiter)){
			selected_iter = aiter;
			return (Elemento)ans.get_object();
		}
		return null;
	}
	
	public bool set_selected(string path_string){
		stdout.printf(path_string);
		Gtk.TreePath path = new Gtk.TreePath.from_string(path_string);
		Gtk.TreeIter aiter;	
		list_store.get_iter (out aiter, path);
		if(list_store.iter_is_valid(aiter)){			
			return set_selected_iter(aiter);
		}
		return false;
	}
	public string? get_selected(){
		if(list_store.iter_is_valid(selected_iter)){
			Gtk.TreePath treepath = list_store.get_path(selected_iter);
			return treepath.to_string();
		}
		return null;
	}
	private bool set_selected_iter(Gtk.TreeIter aiter){
		if(list_store.iter_is_valid(aiter)){			
			string previous = this.text;
			GLib.Value ans;
			list_store.get_value(aiter,0,out ans);		
			text = ans.get_string();
			list_store.get_value(aiter,1,out ans);		
			Elemento objeto= (Elemento)ans.get_object();
			stdout.printf(objeto.nombre);
			stdout.printf("EEEEEEEEEEEIIIIIIIIIIIIUUUUUEEEEEEEEE\n");
			if((previous != text)&&(objeto!=null)){
				selected_iter = aiter;
				stdout.printf(objeto.nombre);
				stdout.printf("EEEEEEEEEEEIIIIIIIIIIIIUUUUUEEEEEEEEE\n");
				selected_signal(objeto);
				return true;
			} 
		}
		return false;
	}
	private GLib.List<MS?> get_names(){
		GLib.List<MS?> list = new List<MS?>();
		Gtk.TreeIter aiter;
		if(list_store.get_iter_first(out aiter)){
			GLib.Value data;
			list_store.get_value(aiter,0,out data);
			MS element = MS(){
				name = data.get_string().casefold(),
				iter = aiter
			};
			list.append(element);
			while(list_store.iter_next(ref aiter)){
				list_store.get_value(aiter,0,out data);
				element = MS(){
					name = data.get_string().casefold(),
					iter = aiter
				};
				list.append(element);
			}			
		}
		return list;
	}
	private void on_icon_press(Gtk.EntryIconPosition icon_pos, Gdk.Event event){
		if(icon_pos == Gtk.EntryIconPosition.PRIMARY){
			if(text.length>0){
				GLib.List<MS?> names = get_names();
				string searchfor=text.casefold();
				foreach(MS name in names){
					if(name.name.length>=searchfor.length && searchfor==name.name[0:searchfor.length]){
						stdout.printf("eeeooo\n");
						stdout.printf(name.name+"\n");					
						set_selected_iter(name.iter);						
						return;
					}
				}
			}
			Gtk.TreeIter aiter;
			if(list_store.get_iter_first(out aiter)){
				set_selected_iter(aiter);
			}
		}else{
			Gtk.TreeIter aiter;
			if(list_store.get_iter_first(out aiter)){
				set_selected_iter(aiter);
			}
		}
	}
	                           
	private bool on_match_selected(Gtk.EntryCompletion sender, Gtk.TreeModel treemodel, Gtk.TreeIter treeiter) {
		return set_selected_iter(treeiter);			
	}
	public void clear(){
		this.list_store.clear();
	}
	public void set_values(GLib.List<Elemento> values){
		list_store.clear();
		Gtk.TreeIter iter;
		foreach(Elemento elemento in values){
			list_store.append (out iter);
			list_store.set (iter, 0, elemento.nombre);
			list_store.set (iter, 1, elemento);
		}
		Gtk.TreeIter aiter;
		if(list_store.get_iter_first(out aiter)){
			set_selected_iter(aiter);
		}		
	}

}

