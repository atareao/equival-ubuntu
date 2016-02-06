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
 /*
struct MS{
	string name;
	Gtk.TreeIter iter;
}
*/
public class HoloSelector : Gtk.TreeView {
	public signal void selected_signal(Elemento elemento);	
	private Gtk.TreeIter selected_iter;
	// Constructor
	public HoloSelector () {
		model = new Gtk.ListStore (2, typeof (string), typeof (Elemento));
	}
	/*
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
	*/
	public Elemento? get_selected_elemento(){
		return get_elemento(selected_iter);
	}
	public Elemento? get_elemento(Gtk.TreeIter aiter){
		GLib.Value ans;
		model.get_value(aiter,1,out ans);
		selected_iter = aiter;
		return (Elemento)ans.get_object();
	}
	
	public bool set_selected(string path_string){
		stdout.printf(path_string);
		Gtk.TreePath path = new Gtk.TreePath.from_string(path_string);
		Gtk.TreeIter aiter;	
		model.get_iter (out aiter, path);
		return set_selected_iter(aiter);
	}
	public string? get_selected(){
		Gtk.TreePath treepath = model.get_path(selected_iter);
		return treepath.to_string();
	}
	private bool set_selected_iter(Gtk.TreeIter aiter){
		GLib.Value ans;
		model.get_value(aiter,0,out ans);		
		model.get_value(aiter,1,out ans);		
		Elemento objeto= (Elemento)ans.get_object();
		stdout.printf(objeto.nombre);
		stdout.printf("EEEEEEEEEEEIIIIIIIIIIIIUUUUUEEEEEEEEE\n");
		if(objeto!=null){
			selected_iter = aiter;
			stdout.printf(objeto.nombre);
			stdout.printf("EEEEEEEEEEEIIIIIIIIIIIIUUUUUEEEEEEEEE\n");
			selected_signal(objeto);
			return true;
		} 
		return false;
	}
	/*
	private GLib.List<MS?> get_names(){
		GLib.List<MS?> list = new List<MS?>();
		Gtk.TreeIter aiter;
		if(model.get_iter_first(out aiter)){
			GLib.Value data;
			model.get_value(aiter,0,out data);
			MS element = MS(){
				name = data.get_string().casefold(),
				iter = aiter
			};
			list.append(element);
			while(model.iter_next(ref aiter)){
				model.get_value(aiter,0,out data);
				element = MS(){
					name = data.get_string().casefold(),
					iter = aiter
				};
				list.append(element);
			}			
		}
		return list;
	}
	*/
	/*
	private bool on_match_selected(Gtk.EntryCompletion sender, Gtk.TreeModel treemodel, Gtk.TreeIter treeiter) {
		return set_selected_iter(treeiter);			
	}
	*/
	public void clear(){
		this.model = new Gtk.ListStore (2, typeof (string), typeof (Elemento));
	}
	public void set_values(GLib.List<Elemento> values){
		Gtk.ListStore list_store = new Gtk.ListStore (2, typeof (string), typeof (Elemento));
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
		this.model = list_store;
	}

}

