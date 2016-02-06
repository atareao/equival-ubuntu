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

public class Comun {
	// Variables
	public const string APP = "equival";
	public const string ICON_FILE = "equival.svg";
	public const string DATA_FILE = "equival.db";
	public const string GETTEXT_PACKAGE = APP;
	public static string CONFIG_DIR = GLib.Path.build_filename (GLib.Environment.get_user_config_dir(),APP);
	public static string CONFIG_FILE = GLib.Path.build_filename (CONFIG_DIR,APP+".conf");
	// PARAMS
	public GLib.HashTable<string, string> _params= new GLib.HashTable<string, string> (str_hash, str_equal);
	//
	public Json.Object objeto {get; set;}
	// Constructor
	public Comun (){
		set_default();
	}
	public void set_default(){
		_params.insert("magnitud","0");
		_params.insert("unidad1","0");
		_params.insert("unidad2","0");
	}
	public void set_param(string key, string avalue){
		if(_params.contains(key)){
			_params[key] = avalue;
		}
	}
	public string get_param(string key){
		return _params.get(key);
	}
	public GLib.List<weak string> get_keys(){
		return _params.get_keys();
	}
}

