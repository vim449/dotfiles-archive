# ##### BEGIN GPL LICENSE BLOCK #####
#
#  This program is free software; you can redistribute it and/or
#  modify it under the terms of the GNU General Public License
#  as published by the Free Software Foundation; either version 2
#  of the License, or (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this program; if not, write to the Free Software Foundation,
#  Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
#
# ##### END GPL LICENSE BLOCK #####

# Project Name:        Poliigon Material Converter
# License:             GPL
# Authors:             Patrick W. Crawford, Google LLC, Poliigon
# Disclaimer:          This is not an official Google Product


bl_info = {
	"name":        "Poliigon Material Converter",
	"description": "Load materials into blender downloaded from Poliigon.com",
	"author":      "Patrick W. Crawford, Poliigon <support@poliigon.com>",
	"version":     (3, 0, 1),
	"blender":     (2, 80, 0),
	"location":    "Properties > Materials > Poliigon Material Converter",
	"warning":     "",  # used for warning icon and text in addons panel
	"wiki_url":    "https://help.poliigon.com/tools-and-add-ons/poliigon-material-converter-addon-for-blender",
	"tracker_url": "https://help.poliigon.com",
	"category":    "Material"
	}


if "bpy" in locals():
	import importlib
	importlib.reload(addon_updater_ops)
	importlib.reload(poliigon_converter)
	importlib.reload(poliigon_ops_props)
	importlib.reload(poliigon_ui)
else:
	from . import addon_updater_ops
	from . import poliigon_converter
	from . import poliigon_ops_props
	from . import poliigon_ui

import bpy


def register():
	addon_updater_ops.register(bl_info)
	poliigon_ops_props.register()
	poliigon_ui.register()


def unregister():
	poliigon_ui.unregister()
	poliigon_ops_props.unregister()
	addon_updater_ops.unregister()


if __name__ == "__main__":
	register()
