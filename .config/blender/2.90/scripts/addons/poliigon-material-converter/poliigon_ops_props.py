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

import os
import json

import bpy
from bpy.app.handlers import persistent
from bpy_extras.io_utils import ImportHelper

use_icons = False
try:
	import bpy.utils.previews
	use_icons = True
except:
	pass

from . import addon_updater_ops
from .poliigon_converter import PMC_workflow
from .poliigon_converter import get_preferences


# -----------------------------------------------------------------------------
# GLOBALS
# -----------------------------------------------------------------------------


global preview_collections
preview_collections = {}
global config_data
config_data = {}

# list of valid filename endings, non case-sensitive (but keep these lowercase)
imgtypes = [".bmp",".sgi",".rgb",".bw",".png", ".jpg",".jpeg",".jp2",".j2c",
			".tga",".cin",".dpx",".exr",".hrd",".tiff",".tif"]
MAX_SEARCH_DEPTH = 5 # inclusive, folder levels deep for searching for images

MAPPING_ITEMS = (
	("uv_uber_mapping", "UV + UberMapping", "Use UV coordinate type mapping, and the Poliigon mapping node group"),
	("uv_standard", "UV + Standard Mapping", "Use UV coordinate type mapping, and built in mapping node"),
	("flat_standard", "Generated (Flat) + Standard Mapping", "Use generated coordinate type mapping, and built in mapping node"),
	("box_standard", " Generated (Box) + Standard Mapping", "Use box coordinate type mapping, and built in mapping node")
)

# -----------------------------------------------------------------------------
# FUNCTIONS
# -----------------------------------------------------------------------------


def print_verbose(*args):
	"""Print only if verbose enabled"""
	prefs = get_preferences()
	if not prefs:
		# default to print?
		print(" ".join(map(str, args)))
	if prefs.verbose:
		print(" ".join(map(str, args)))


def load_file_sets_from_path(path):
	"""Load folder and subfolder of image files"""

	path = bpy.path.abspath(path)
	if not os.path.isdir(path):
		return []

	# recursive find images down to three levels deep of subfolders
	subfiles = []
	for root, dirs, files in os.walk(path, topdown=True):
		depth = root[len(path) + len(os.path.sep):].count(os.path.sep)
		if depth < MAX_SEARCH_DEPTH:
			# We're currently two directories in, so all subdirs have depth 3
			subfiles += [os.path.join(root, d) for d in files \
						if os.path.splitext(d)[-1] in imgtypes]

	# consoldiate/extract the base name paths for the material sets
	paths = PMC_workflow.get_sets_from_filenames(None, subfiles)

	# build format to pass through to loading popup operator
	file_sets = [{"name" : "", "setpath" : p, "warning":""} for p in paths]

	# print_verbose("Poliigon, detected filesets:", file_sets)
	return file_sets


def folderset_list_update(context, items):
	"""Triggered to re-draw/load the list, called after folder name changes"""
	pmcprop = context.window_manager.pmc_props
	pmcprop.folderset_list.clear()

	# clear existing thumbnails, if any
	material_thumbs = preview_collections["materials"]
	material_thumbs.clear()

	workflow = PMC_workflow() # reusing same object
	items_sorted = []

	for itm in items:
		# load with dryrun, so won't actually build material, just get settings
		status, _ = workflow.build_material_from_set(context, itm["setpath"], dryrun=True)
		items_sorted.append([itm, status.copy(),
							 workflow.build_name(),
							 workflow.workflow,
							 workflow.get_thumbnail(pmcprop.preview_type)])

	# zip sorting based on to-be-made material name
	n = [new[2] for new in items_sorted] # ie actual build name
	fallback = range(0,len(n)) # in case of name clash, use starting order
	items_sorted = [new[-1] for new in sorted(zip(n,fallback,items_sorted))]

	# list the non-specular workflows found
	non_spec = [itm[2] for itm in items_sorted if itm[3] != "SPECULAR"]

	for i, (itm, status, build_name, itm_workflow, thumbnail) in enumerate(items_sorted):
		# skip if specular and non-spec exists
		if itm_workflow == "SPECULAR" and build_name in non_spec:
			continue

		if thumbnail:
			thumb_id = i
			_ = material_thumbs.load(str(thumb_id), thumbnail, 'IMAGE')
		else:
			thumb_id = -1

		item = pmcprop.folderset_list.add()
		item.label = "{} material set".format(build_name)
		item.description = build_name
		item.name = build_name
		item.setpath = itm["setpath"]
		item.checked = True
		item.loaded = False
		item.materialname = build_name
		item.thumb_id = thumb_id

		urllist = workflow.splitMaterialName(build_name)
		urlend = ''
		for a in urllist:
			urlend += a+"%20"
		item.urlend = urlend[:-3]

		if status != {}:
			item.checked = False

		# distinguish if already loaded (show check), or just material name overlap
		for m in bpy.data.materials:
			if m.pmc_matprops.setpath == itm['setpath']:
				item.checked = False
				item.loaded = True
				item.materialname = m.name

		# in all cases, dump status - if all is good, then is equal to "{}",
		# used for drawing in list ui
		item.status = json.dumps(status)

	# Finally, update the row index if needed
	if len(pmcprop.folderset_list) <= pmcprop.folderset_list_index:
		pmcprop.folderset_list_index = len(pmcprop.folderset_list)-1


def folderset_update(self, context):
	items = load_file_sets_from_path(context.window_manager.pmc_texture_path)
	folderset_list_update(context, items)


def deselect_all_update(self, context):
	""" Triggered when the deselect_property is toggled"""
	pmcp = context.window_manager.pmc_props

	# skip if being internally modified, or nothing loaded yet anyways
	if pmcp.deselect_all_internal is True:
		return
	elif not pmcp.folderset_list:
		return

	pmcp.check_toggle_internal = True
	if pmcp.deselect_all is True:
		for itm in pmcp.folderset_list:
			if itm.checked is True:
				itm.checked = False
	else:
		any_checked = False
		for itm in pmcp.folderset_list:
			if itm.loaded is False:
				itm.checked = True
				any_checked = True
				# consider restricting to only checking True those without errors
		if not any_checked:
			# scenario where everything is already loaded, so flip deselect
			# back to being on (as nothing is selected)
			# Will have UI behavior of clicking, but it staying on
			pmcp.deselect_all_internal = True
			pmcp.deselect_all = True
			pmcp.deselect_all_internal = False

	pmcp.check_toggle_internal = False
	return


def folderset_list_col_checked_update(self, context):
	"""Triggered when a detected material's checkmark is toggled"""
	pmcp = context.window_manager.pmc_props
	if pmcp.check_toggle_internal is True:
		return
	anychecks = [itm.checked for itm in pmcp.folderset_list \
				if itm.checked is True]

	# set the state of the deselect button accordingly
	pmcp.deselect_all_internal = True
	if True not in anychecks:
		pmcp.deselect_all = True
	else:
		pmcp.deselect_all = False
	pmcp.deselect_all_internal = False


def get_json_path():
	"""Returns primary path for json config data"""
	return os.path.join(os.path.dirname(__file__),"config.json")


def load_json():
	"""Load values of json config values"""
	json_path = get_json_path()
	if not os.path.isfile(json_path):
		return {}
	try:
		infile = open(json_path,'r')
		data = json.load(infile)
		infile.close()
		return data
	except:
		return {}


def save_json_key(key, value):
	"""Save key to json file."""
	global config_data
	config_data = load_json()
	config_data[key] = value

	with open(get_json_path(), 'w') as outfile:
		json.dump(config_data, outfile)

	# reload the property with updated default
	register_texture_path()


def default_texture_path():
	"""Default value for the textures path."""
	global config_data
	config_data = load_json()
	if "texture_path" in config_data:
		return config_data["texture_path"]
	else:
		return "//"

@persistent
def load_post(scene):
	"""Runs after opening a file, such as fresh open."""
	config_data = load_json()
	if config_data == {}:
		return
	elif 'texture_path' not in config_data:
		return
	elif config_data['texture_path'] == "//":
		return

	# this will cause some delay on reload, depending on size of folder set
	bpy.ops.pmc.refresh_folder()


def register_texture_path():
	"""Function to on-the-fly deregister and register the texturepath."""

	if hasattr(bpy.types.WindowManager, "pmc_texture_path"):
		del bpy.types.WindowManager.pmc_texture_path

	bpy.types.WindowManager.pmc_texture_path = bpy.props.StringProperty(
		name = "Textures folder",
		description = "Folder or folder of folders of material images",
		subtype = 'DIR_PATH',
		update = folderset_update,
		default = default_texture_path()
	)


def get_material_thumbnails(self, context):
	"""Function to return thumbnails for UI drawing"""

	# must save to global variable to avoid known blender enum strings issue
	global ENUM_THUMBNAIL_LIST
	ENUM_THUMBNAIL_LIST = []

	pmaterials = preview_collections["materials"]
	pmain = preview_collections["main"]

	pmcprop = context.window_manager.pmc_props
	for i, material_set in enumerate(pmcprop.folderset_list):
		if not pmaterials and (not pmain or "no_preview" not in pmain):
			icon = "ERROR"
		elif not pmaterials:
			icon = pmain["no_preview"].icon_id
		elif material_set.thumb_id == -1:
			icon = pmain["no_preview"].icon_id
		else:
			if str(material_set.thumb_id) not in pmaterials:
				print("Error! {} not in thumbs".format(material_set.thumb_id))
				icon = pmain["no_preview"].icon_id
			else:
				temp = pmaterials[str(material_set.thumb_id)]
				icon = temp.icon_id

		ENUM_THUMBNAIL_LIST.append((
			str(i),
			str(material_set.name),
			"Preview the material {}".format(material_set.name),
			icon,
			i, # retain order
		))
	return ENUM_THUMBNAIL_LIST


def update_folderset_list_index(self, context):
	"""Update trigger to adjust thumbnail if select UI row is changed"""
	pmcprop = context.window_manager.pmc_props
	if pmcprop.check_toggle_internal is True:
		return
	if not pmcprop.folderset_list:
		return
	pmcprop.check_toggle_internal = True
	pmcprop.thumbnails = str(pmcprop.folderset_list_index)
	pmcprop.check_toggle_internal = False


def update_material_thumbnails(self, context):
	"""Trigger called to update thumbnails"""
	pmcprop = context.window_manager.pmc_props
	if pmcprop.check_toggle_internal is True:
		return
	pmcprop.check_toggle_internal = True
	pmcprop.folderset_list_index = int(pmcprop.thumbnails)
	pmcprop.check_toggle_internal = False


# -----------------------------------------------------------------------------
# OPERATORS / SUPPORT CLASSES
# -----------------------------------------------------------------------------


class PathItem(bpy.types.PropertyGroup):
	"""Class to pass group of image paths from one operator to the next"""
	setpath = bpy.props.StringProperty(name="Set path")
	warning = bpy.props.StringProperty(name="Warning")


class PMC_load_materials_from_UIList(bpy.types.Operator):
	bl_idname = "pmc.load_materials_from_uilist"
	bl_label = "Load materials"
	bl_description = "Load all checked materials in list"
	bl_options = {'REGISTER', 'UNDO', 'INTERNAL'}

	def execute(self,context):
		pmcs = context.scene.pmc_sceneprops
		file_sets = [{"name" : "", "setpath" : itm.setpath, "warning":itm.status} \
			for	itm in context.window_manager.pmc_props.folderset_list.values() \
			if itm.checked is True]
		bpy.ops.pmc.load_material_popup(#'INVOKE_DEFAULT',
				file_sets=file_sets,
				loading_from_uilist=True,
				use_ao=pmcs.use_ao,
				use_disp=pmcs.use_disp,
				use_sixteenbit=pmcs.use_sixteenbit,
				conform_uv=pmcs.conform_uv,
				use_micro_displacements=pmcs.use_micro_displacements,
				mapping_type=pmcs.mapping_type
				)
		return {'FINISHED'}


class PMC_load_and_apply_material(bpy.types.Operator):
	bl_idname = "pmc.load_and_apply_material"
	bl_label = "Load & Apply Material"
	bl_description = "Load (or reload) and apply highlighted material"
	bl_options = {'REGISTER', 'UNDO', 'INTERNAL'}

	index = bpy.props.IntProperty(options={'HIDDEN'})

	@classmethod
	def poll(cls, context):
		# disable operator if material already loaded
		ind = bpy.context.window_manager.pmc_props.folderset_list_index
		if not bpy.context.window_manager.pmc_props.folderset_list:
			return False
		if len(bpy.context.window_manager.pmc_props.folderset_list) <= ind:
			return False
		else:
			return True

	def execute(self,context):
		pmcs = context.scene.pmc_sceneprops
		itm = context.window_manager.pmc_props.folderset_list[self.index]
		file_sets = [{"name" : "", "setpath" : itm.setpath, "warning":itm.status}]
		bpy.ops.pmc.load_material_popup(
				file_sets=file_sets,
				loading_from_uilist=True,
				use_ao=pmcs.use_ao,
				use_disp=pmcs.use_disp,
				use_sixteenbit=pmcs.use_sixteenbit,
				conform_uv=pmcs.conform_uv,
				use_micro_displacements=pmcs.use_micro_displacements,
				mapping_type=pmcs.mapping_type
				)

		if context.selected_objects:
			bpy.ops.pmc.apply_material('INVOKE_DEFAULT', index=self.index)
			if pmcs.use_disp:
				self.report({"WARNING"}, "Default displacement = 0, consider adjusting")
		else:
			self.report({"WARNING"}, "No objects selected to apply material")
		return {'FINISHED'}


class PMC_load_material_popup(bpy.types.Operator):
	"""Executes material loading, no longer used as a popup however"""
	bl_idname = "pmc.load_material_popup"
	bl_label = "Load Material Settings"
	bl_description = "Confirm settings for loading materials"
	bl_options = {'REGISTER', 'UNDO', 'INTERNAL'}

	# sets of materials based on filenames, already made unique
	file_sets = bpy.props.CollectionProperty(type=PathItem)

	# additional loading settings
	loading_from_uilist = bpy.props.BoolProperty(
		default=False,
		options={"HIDDEN"}
	)
	use_ao = bpy.props.BoolProperty(
		name="Include Ambient Occlusion (AO)",
		description="Use Ambient Occlusion maps (if available)",
		default=True
	)
	use_disp = bpy.props.BoolProperty(
		name="Include Displacement maps",
		description="Use Displacement maps (if available)",
		default=True
	)
	use_sixteenbit = bpy.props.BoolProperty(
		name="Use 16 bit maps (if available)",
		description="Use 16 bit maps (if available)",
		default=False
	)
	conform_uv = bpy.props.BoolProperty(
		name="Conform maps to image dimensions",
		description="Set mapping-node scale to ensure uniform UVs",
		default=True
	)
	use_micro_displacements = bpy.props.BoolProperty(
		name="Use micro-displacements (if available, enables experimental)",
		description="Enable micro displacements using adaptive subdivision. "+\
		"Note! This will enable blender's experimental mode if not already active",
		default=False
	)
	mapping_type = bpy.props.EnumProperty(
		name="Coordinate type",
		description="Determine what method of texture coordiantes to use",
		items=MAPPING_ITEMS
	)

	def execute(self, context):
		pmcs = context.scene.pmc_sceneprops
		pmcp = context.window_manager.pmc_props
		# ensure the pricnipled shader exists
		if not hasattr(bpy.types, 'ShaderNodeBsdfPrincipled'):
			print("Poliigon: Blender is missing required BSDF Principled shader, use blender 2.79+")
			self.report({"ERROR","Blender is missing required BSDF Principled shader"})
			return {'CANCELLED'}

		# ensure at least one set is included
		if not self.file_sets:
			print("Poliigon: No paths included, nothing imported")
			self.report({"INFO"},"No paths included, nothing imported")
			return {'CANCELLED'}

		print_verbose("Poliigon: Running load materials, {} sets identified".format(
				len(self.file_sets)))
		paths = [name.setpath for name in self.file_sets] # convert to paths
		added_materials = []
		added_objects = []
		imported_models = False
		initial_active = context.active_object
		if bpy.app.version < (2, 80):
			self.use_micro_displacements = False

		# previously could load multiple materials at once, though now only one
		for set_path in paths:
			print_verbose("Poliigon: Loading "+set_path)
			# will auto initialize material builder
			workflow = PMC_workflow(
					use_ao=self.use_ao,
					use_disp=self.use_disp,
					use_sixteenbit=self.use_sixteenbit,
					conform_uv=self.conform_uv,
					microdisp=self.use_micro_displacements,
					mapping=self.mapping_type
					)
			status, material = workflow.build_material_from_set(context,set_path)
			added_materials.append((status, material))

			# Load OBJ if file exists
			# (must truncate the size off of setpath, e.g. '_4K')
			model_basename = workflow.setpath[:-(1+len(workflow.size))]
			obj_path = model_basename + ".obj"
			fbx_path = model_basename + ".fbx"
			new_objects = []
			if not pmcs.import_object:
				pass
			elif os.path.isfile(obj_path):
				print_verbose("Poliigon: Found OBJ to import "+obj_path)
				try:
					initial_objs = list(bpy.data.objects)
					bpy.ops.import_scene.obj(filepath=obj_path)
					new_objects = list( set(bpy.data.objects) - set(initial_objs))
				except Exception as e:
					print_verbose("Poliigon: Failed to import OBJ model: "+str(e))
			elif os.path.isfile(fbx_path):
				print_verbose("Poliigon: Found FBX to import "+fbx_path)
				try:
					initial_objs = list(bpy.data.objects)
					bpy.ops.import_scene.fbx(filepath=fbx_path)
					new_objects = list(set(bpy.data.objects) - set(initial_objs))
				except Exception as e:
					print_verbose("Poliigon: Failed to import FBX model: "+str(e))
					new_objects = []

			if new_objects:
				print_verbose("Poliigon: Model objects imported, applying settings ")
				imported_models = True
				added_objects += new_objects
				for ob in new_objects:
					ob.data.materials.clear() # clears materials, not slots
					ob.active_material_index = 0 # ensure first slot is used
					ob.active_material = material # auto-creates slot
					print_verbose("Poliigon: \tAdded material to "+ob.name)

				print_verbose("Poliigon: Model imported and material applied")

				# attempt to make paths relative
				if bpy.data.filepath=='':
					print_verbose("File not saved, could not make paths relative")
				else:
					print_verbose("attemping to make relative paths")
					workflow.set_relative()

			# update the UI list flag as imported
			ui_set = [row for row in pmcp.folderset_list
				if row.setpath == set_path]
			if ui_set:
				ui_set[0].loaded = True
			else:
				print_verbose("Poliigon: Could not directly mark material as loaded, full reloading")

			# clear the material setpath of other previously imported materials
			existing_mats = [mat for mat in bpy.data.materials
				if mat.pmc_matprops.setpath == material.pmc_matprops.setpath
				and mat != material]
			for mat in existing_mats:
				mat.pmc_matprops.setpath = "" # cleared to not apply old mat

		self.report({'INFO'},"Loaded {} materials".format(len(added_materials)))
		print_verbose("Poliigon: Loaded {} materials".format(len(added_materials)))
		# folderset_update(self, context)

		if imported_models:
			# if auto-imported models, do some additional cleanup
			if initial_active:
				bpy.data.objects.remove(initial_active)
			if added_objects:
				if hasattr(bpy.data, "collections"): # 2.8
					group = bpy.data.collections.new(os.path.basename(model_basename))
				else:
					group = bpy.data.groups.new(os.path.basename(model_basename))
				for ob in added_objects:
					group.objects.link(ob)
					if hasattr(ob, "select_set"): # 2.8
						ob.select_set(True)
					else:
						ob.select = True
			# make at least one of the objects active
			if hasattr(context, "view_layer"):
				context.view_layer.objects.active = added_objects[0] # the 2.8 way
			else:
				context.scene.objects.active = added_objects[0] # the 2.7 way
			bpy.ops.object.transforms_to_deltas(mode='ROT', reset_values=True)

		return {'FINISHED'}


class PMC_refresh_folder(bpy.types.Operator):
	bl_idname = "pmc.refresh_folder"
	bl_label = "Refresh Poliigon Material Folder"
	bl_description = "Click to refresh folder for loading Poliigon textures"

	def execute(self, context):
		folderset_update(self, context)
		return {'FINISHED'}


class PMC_apply_material(bpy.types.Operator):
	bl_idname = "pmc.apply_material"
	bl_label = "Apply Material"
	bl_description = "Replace all materials on selected meshes with the selected material"
	bl_options = {'REGISTER', 'UNDO', 'INTERNAL'}

	index = bpy.props.IntProperty(options={'HIDDEN'})

	@classmethod
	def poll(cls, context):
		ind = bpy.context.window_manager.pmc_props.folderset_list_index
		if len(bpy.context.window_manager.pmc_props.folderset_list)!=0:
			itm = bpy.context.window_manager.pmc_props.folderset_list[ind]
			if itm.loaded:
				return True
			else:
				return False
		else:
			return False

	def execute(self, context):
		addon_prefs = get_preferences(context)
		pmcs = context.scene.pmc_sceneprops
		if not addon_prefs:
			verbose = None
		else:
			verbose = addon_prefs.verbose

		itm = context.window_manager.pmc_props.folderset_list[self.index]
		# mat = itm.materialname

		valid_mats = [mat for mat in bpy.data.materials
			if mat.pmc_matprops.setpath == itm.setpath]
		if not valid_mats:
			self.report({"ERROR"},"Could not apply material to object, material not matched")
			print_verbose("Could not apply material to object, material not matched")
			return {'CANCELLED'}
		mat = valid_mats[-1] # select one, though shouldn't be duplciates really

		# list of selected objects which can have materials applied (must support UVs)
		# TODO, consider expanding availability
		objs = [ob for ob in context.selected_objects if hasattr(ob.data,"uv_layers")]

		if len(context.selected_objects)==0:
			self.report({"ERROR"},"No objects selected to apply materials")
			return {'CANCELLED'}
		elif len(objs)==0:
			self.report({"ERROR"},"No objects selected supporting materials")
			print_verbose("No objects selected supporting materials")
			return {'CANCELLED'}

		count_no_UV = 0

		if verbose:
			print("Applying materials for these objects:")
			print(objs)

		# clear existing materials, and apply micro displacements if appropriate
		for ob in objs:
			# ob.data.materials.clear() # clears materials, not slots
			# ob.active_material_index = 0 # ensure first slot is used
			ob.active_material = mat # auto-creates slot if needed

			# add adaptive subdiv if micro displacements set to true, and experimental
			if mat.pmc_matprops.use_micro_displacements:
				if not hasattr(ob, "cycles"):
					print_verbose("Poliigon: Cycles not available, cannot set adaptive subdivision")
				elif not hasattr(ob.cycles, "use_adaptive_subdivision"):
					print_verbose("Poliigon: No adaptive subdivision available")
				else:
					ob.cycles.use_adaptive_subdivision = True
					any_subsurf = len([mod for mod in ob.modifiers if mod.type=="SUBSURF"])>0
					if not any_subsurf:
						mod = ob.modifiers.new(type='SUBSURF', name="Micro Subsurf")
						mod.levels=0
						mod.render_levels=0
			if len(ob.data.uv_layers)==0:
				count_no_UV += 1
				print_verbose("Object is missing UVs for applying materials: "+
						ob.name)

		if count_no_UV > 0 and pmcs.mapping_type in ('uv_uber_mapping', 'uv_standard'):
			# Only warn if using a UV approach
			print_verbose("No UV layers found on "+str(count_no_UV)+
						" of selected objects, please unwrap meshes")
			bpy.ops.pmc.missing_uv_warnings(
				'INVOKE_DEFAULT', count_missing_uvs=count_no_UV)
		return {'FINISHED'}


class PMC_missing_UV_warnings(bpy.types.Operator):
	bl_idname = "pmc.missing_uv_warnings"
	bl_label = "Objects Missing UVs"
	bl_description = "Warning popup for when there are missing UVs on material-applied objects"
	bl_options = {'INTERNAL'}

	count_missing_uvs = bpy.props.IntProperty(options={'HIDDEN'})

	def invoke(self, context, event):
		return context.window_manager.invoke_props_dialog(self)

	def draw(self, context):
		layout = self.layout
		col = layout.column()
		col.scale_y = 0.7
		col.label(text="No UV layers found on {} of the  selected objects,".format(
				self.count_missing_uvs),
				icon="ERROR")
		if self.count_missing_uvs==1:
			col.label(text="please unwrap mesh", icon="BLANK1")
		else:
			col.label(text="please unwrap meshes", icon="BLANK1")

	def execute(self, context):
		return {'FINISHED'}


class PMC_set_default_path(bpy.types.Operator):
	bl_idname = "pmc.set_default_path"
	bl_label = "Save path"
	bl_description = "Save as the default path for loading textures"
	bl_options = {'REGISTER', 'UNDO', 'INTERNAL'}

	def execute(self, context):
		path = context.window_manager.pmc_texture_path
		save_json_key("texture_path", path)
		return {'FINISHED'}


class PMC_unset_default_path(bpy.types.Operator):
	bl_idname = "pmc.unset_default_path"
	bl_label = "Apply Material"
	bl_description = "Remove this custom path for loading textures"
	bl_options = {'REGISTER', 'UNDO', 'INTERNAL'}

	def execute(self, context):
		context.window_manager.pmc_texture_path = "//"
		save_json_key("texture_path", "//")
		return {'FINISHED'}


class PMC_remove_unused_materials(bpy.types.Operator):
	bl_idname = "pmc.remove_unused_materials"
	bl_label = "Remove Unused Materials"
	bl_description = "Removes all unused materials imported by the Poliigon converter"
	bl_options = {'REGISTER', 'UNDO', 'INTERNAL'}

	def execute(self,context):
		removed_mats = 0
		removed_images = 0

		materials = [material for material in bpy.data.materials
			if material.pmc_matprops
			and material.pmc_matprops.setpath # not empty, thus from converter
			and ((material.users == 0 and not material.use_fake_user)
				or (material.users == 1 and material.use_fake_user))
			]
		material_images = []

		for mat in materials:
			if mat.node_tree and mat.node_tree.nodes:
				material_images += [
					node.image for node in mat.node_tree.nodes
					if node.type == "TEX_IMAGE"
					and node.image]

			mat.use_fake_user = False
			bpy.data.materials.remove(mat)
			removed_mats += 1

		for image in material_images:
			if not image.users == 0:
				continue
			image.user_clear()
			bpy.data.images.remove(image)
			removed_images += 1

		folderset_update(self, context)
		if removed_images > 0 or removed_mats > 0:
			self.report({"INFO"}, "Removed {} materials and {} images".format(
				removed_mats, removed_images))
		else:
			self.report({"WARNING"}, "No materials or images removed")
		return {'FINISHED'}


# -----------------------------------------------------------------------------
# PREFERENCES AND PROPERTY GROUPS
# -----------------------------------------------------------------------------


class PMC_preferences(bpy.types.AddonPreferences):
	bl_idname = __package__

	verbose = bpy.props.BoolProperty(
		name = "Verbose",
		description = "Print out more logging information, for debugging",
		default = False)

	# addon updater preferences

	auto_check_update = bpy.props.BoolProperty(
		name="Auto-check for update every week",
		description="If enabled, auto-check for updates using an interval",
		default=False,
		)
	updater_intrval_months = bpy.props.IntProperty(
		name='Months',
		description="Number of months between checking for updates",
		default=0,
		min=0
		)
	updater_intrval_days = bpy.props.IntProperty(
		name='Days',
		description="Number of days between checking for updates",
		default=7,
		min=0,
		)
	updater_intrval_hours = bpy.props.IntProperty(
		name='Hours',
		description="Number of hours between checking for updates",
		default=0,
		min=0,
		max=23
		)
	updater_intrval_minutes = bpy.props.IntProperty(
		name='Minutes',
		description="Number of minutes between checking for updates",
		default=0,
		min=0,
		max=59
		)

	def draw(self, context):
		layout = self.layout
		if not hasattr(bpy.types, 'ShaderNodeBsdfPrincipled'):
			box = layout.box()
			col = box.column()
			col.scale_y = 0.7
			col.label(text="")
			col.label(text="This blender version is missing required BSDF Principled "+\
					"shader node, use blender v2.79+ to use addon", icon="ERROR")
			col.label(text="")
			return

		mainrow = layout.row()
		col = mainrow.column()
		row = col.row(align=True)
		row.scale_y = 2
		pmain = preview_collections["main"]
		if not pmain or "poliigon_logo" not in pmain:
			p = row.operator("wm.url_open", text="Get more textures")
		else:
			poliigon_icon = pmain["poliigon_logo"]
			p = row.operator("wm.url_open", text="Get more textures",
							icon_value=poliigon_icon.icon_id)
		p.url="http://poliigon.com"
		col.prop(self,"verbose",text="Show verbose logging in console")

		# updater draw function
		col = mainrow.column()
		addon_updater_ops.update_settings_ui_condensed(self, context, col)


# -----------------------------------------------------------------------------
# PROPERTY GROUPS
# -----------------------------------------------------------------------------


class folderset_list_col(bpy.types.PropertyGroup):
	"""Class to register properties to item rows of the to-be-imported list"""
	label = bpy.props.StringProperty(default="")
	description = bpy.props.StringProperty(default="")
	checked = bpy.props.BoolProperty(
		default=True,
		update=folderset_list_col_checked_update)
	setpath = bpy.props.StringProperty(default="")
	status = bpy.props.StringProperty(default="{}") # json format
	loaded = bpy.props.BoolProperty(default=False)
	materialname = bpy.props.StringProperty(default="")
	urlend = bpy.props.StringProperty(default="")
	thumb_id = bpy.props.IntProperty()


class PMC_props(bpy.types.PropertyGroup):
	"""Class to register properties to window, not saved with settings or file"""
	folderset_list = bpy.props.CollectionProperty(type=folderset_list_col)
	folderset_list_index = bpy.props.IntProperty(
		default=0,
		update=update_folderset_list_index)
	show_advanced = bpy.props.BoolProperty(
		name = "Advanced Options",
		description = "Show additional advanced options",
		default=False)
	deselect_all = bpy.props.BoolProperty(
		name = "Deselect All",
		description = "Deselect all materials detected, or select all if "+\
					"already deselected",
		default=False,
		update=deselect_all_update)
	deselect_all_internal = bpy.props.BoolProperty(
		description="Internally used property, for use in toggling "+\
					"deselect_all without triggering its update function",
		default=False,
		options={'HIDDEN'}
		)
	check_toggle_internal = bpy.props.BoolProperty(
		description="Internally used property, for use in toggling a detected "+\
					"set's checkmark without triggering its update function",
		default=False,
		options={'HIDDEN'}
		)
	thumbnails = bpy.props.EnumProperty(
		items=get_material_thumbnails,
		update=update_material_thumbnails
	)
	preview_type = bpy.props.EnumProperty(
		name = "Preferred preview",
		items=(
			("sphere", "Sphere", "Display sphere previews, if found", "MESH_UVSPHERE", 0),
			("cube", "Cube", "Display cube previews, if found", "MESH_CUBE", 1),
			("flat", "Flat", "Display flat previews, if found", "MESH_PLANE", 2)),
		update=folderset_update
	)


class PMC_scene_props(bpy.types.PropertyGroup):
	"""Class to register properties to scene, is saved with settings and file"""
	use_ao = bpy.props.BoolProperty(
		name="Include Ambient Occlusion maps (if available)",
		description="Use Ambient Occlusion maps (if available)",
		default=True
	)
	use_disp = bpy.props.BoolProperty(
		name="Include Displacement maps (if available)",
		description="Use Displacement maps (if available)",
		default=True
	)
	use_sixteenbit = bpy.props.BoolProperty(
		name="Use 16 bit maps (if available)",
		description="Load 16 bit version of texture maps where they exist",
		default=True
	)
	conform_uv = bpy.props.BoolProperty(
		name="Conform maps to image dimensions",
		description="Set the mapping-node scale to ensure uniform, non-stretching UVs",
		default=True
	)
	use_micro_displacements = bpy.props.BoolProperty(
		name="Use micro-displacements (if available, enables experimental)",
		description="Enable micro displacements using adaptive subdivision. "+\
		"Note! This will enable blender's experimental mode if not already active",
		default=False
	)
	mapping_type = bpy.props.EnumProperty(
		name="Coordinate type",
		description="Determine what method of texture coordiantes to use",
		items=MAPPING_ITEMS
	)
	import_object = bpy.props.BoolProperty(
		name="Import models (if found)",
		description="Automatically import associated object models with the material set",
		default=False
	)


class PMC_matprops(bpy.types.PropertyGroup):
	"""Class to register properties to individual materials, saved with file"""
	status = bpy.props.StringProperty(default="")
	workflow = bpy.props.StringProperty(default="")
	setname = bpy.props.StringProperty(default="")
	size = bpy.props.StringProperty(default="")
	setpath = bpy.props.StringProperty(default="") # used for reloading/ticks
	use_ao = bpy.props.BoolProperty(default=True)
	use_disp = bpy.props.BoolProperty(default=True)
	use_sixteenbit = bpy.props.BoolProperty(default=True)
	use_micro_displacements = bpy.props.BoolProperty(default=False)


# -----------------------------------------------------------------------------
# REGISTER / UNREGISTER
# -----------------------------------------------------------------------------


classes = (
	folderset_list_col,
	PathItem,
	PMC_props,
	PMC_scene_props,
	PMC_matprops,
	PMC_load_materials_from_UIList,
	PMC_load_and_apply_material,
	PMC_load_material_popup,
	PMC_refresh_folder,
	PMC_apply_material,
	PMC_missing_UV_warnings,
	PMC_set_default_path,
	PMC_unset_default_path,
	PMC_remove_unused_materials,
	PMC_preferences
	)


def make_annotations(cls):
	"""Converts class fields to annotations if running with Blender 2.8"""
	if bpy.app.version < (2, 80):
		return cls
	bl_props = {k: v for k, v in cls.__dict__.items() if isinstance(v, tuple)}
	if bl_props:
		if '__annotations__' not in cls.__dict__:
			setattr(cls, '__annotations__', {})
		annotations = cls.__dict__['__annotations__']
		for k, v in bl_props.items():
			annotations[k] = v
			delattr(cls, k)
	return cls


def register():
	"""Register classes, properties, and global icons"""
	register_texture_path()

	for cls in classes:
		make_annotations(cls)
		bpy.utils.register_class(cls)

	bpy.types.WindowManager.pmc_props = bpy.props.PointerProperty(type=PMC_props)
	bpy.types.Material.pmc_matprops = bpy.props.PointerProperty(type=PMC_matprops)
	bpy.types.Scene.pmc_sceneprops = bpy.props.PointerProperty(type=PMC_scene_props)

	# try to load poliigon icon
	try:
		script_path = bpy.path.abspath(os.path.dirname(__file__))
		icons_dir = os.path.join(script_path,'icons')
		custom_icons = bpy.utils.previews.new()
		material_thumbs = bpy.utils.previews.new()
		preview_collections["main"] = custom_icons
		preview_collections["materials"] = material_thumbs
	except Exception as e:
		print("Poliigon: Failed to load custom icons, may be old blender version")
		print("\t"+str(e))
		preview_collections["main"] = ""
		preview_collections["materials"] = ""

	if use_icons:
		logo_path = os.path.join(icons_dir, "poliigon-logo.png")
		nopreview_path = os.path.join(icons_dir, "no-preview-icon.png")
		if os.path.isfile(logo_path):
			custom_icons.load("poliigon_logo", logo_path, 'IMAGE')
		if os.path.isfile(nopreview_path):
			custom_icons.load("no_preview", nopreview_path, 'IMAGE')

	# register the new-file handler, to trigger refresh if non-nill path
	if hasattr(bpy.app.handlers, "load_post"):
		bpy.app.handlers.load_post.append(load_post)


def unregister():
	"""Unregister classes, properties, and global icons"""

	# remove icons
	if use_icons and preview_collections["main"] != "":
		for pcoll in preview_collections.values():
			bpy.utils.previews.remove(pcoll)
		preview_collections.clear()

	if hasattr(bpy.types.WindowManager, "pmc_texture_path"):
		del bpy.types.WindowManager.pmc_texture_path
	del bpy.types.WindowManager.pmc_props
	del bpy.types.Material.pmc_matprops

	if hasattr(bpy.app.handlers, "load_post") and \
			load_post in bpy.app.handlers.load_post:
		bpy.app.handlers.load_post.remove(load_post)

	for cls in reversed(classes):
		bpy.utils.unregister_class(cls)
