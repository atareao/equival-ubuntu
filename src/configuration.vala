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
public class Configuration{
	private Comun _comun;
	// Constructor
	public Configuration () {
		_comun = new Comun();
		if (!GLib.FileUtils.test (Comun.CONFIG_FILE, GLib.FileTest.EXISTS)){
			GLib.DirUtils.create_with_parents (Comun.CONFIG_DIR, 0700);
		}
		read();
	}
	public void read(){
		Json.Parser parser = new Json.Parser();
		try{
			if(parser.load_from_file(Comun.CONFIG_FILE)){
				Json.Node root = parser.get_root();
				foreach(var key in _comun._params.get_keys()){
					stdout.printf(key+"\n");
					if(root.get_object().has_member(key)){
						stdout.printf(root.get_object().get_string_member(key));
						stdout.printf("\n");
						_comun._params[key]=root.get_object().get_string_member(key);
						//_comun.set_param(key, root.get_object().get_string_member(key));
					}
				}
			}
		}catch(Error e){
			stdout.printf("Error reading\n");
			stdout.printf(Comun.CONFIG_FILE);
			stdout.printf("\n");
			stdout.printf(e.message);
			stdout.printf("\n");
			if(save()){
				read();
			}
		}
	}
	public bool save(){
		Json.Generator generator = new Json.Generator();
		Json.Node root = new Json.Node(Json.NodeType.OBJECT);
  		Json.Object object = new Json.Object();
  		root.set_object(object);
  		generator.set_root(root);
		foreach(string key in _comun.get_keys()){
			object.set_string_member(key, _comun.get_param(key));
		}
		try{
			generator.to_file(Comun.CONFIG_FILE);
			return true;
		}catch(Error e){
			stdout.printf("Error saving\n");
			stdout.printf(Comun.CONFIG_FILE);
			stdout.printf("\n");
			stdout.printf(e.message);
			stdout.printf("\n");
		}
		return false;
	}
	public string get_param(string key){
		return _comun.get_param(key);
	}
	public void set_param(string key,string avalue){
		_comun.set_param(key,avalue);
	}
}

