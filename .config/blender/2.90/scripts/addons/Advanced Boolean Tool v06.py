#==============================
# THIS ADDON WAS WRITEN BY ND9H (nguyen dang huy)
#==============================
bl_info={
    "name": "ND9H - Advanced Boolean Tool ",
    "description": "Advanced Boolean Tool ",
    "author": "nguyen dang huy (ND9H)",
    "version": (0, 6),
    "blender": (2, 80, 0),
    "location": "Alt+X to open the menu in VIEW3D",
    "warning": "",
    "tracker_url": "https://www.facebook.com/ND9H.Official/",
    "support": "COMMUNITY",
    "category": "All"
}
import bpy
import blf
from re import search
from random import *
from bpy.props import IntProperty, FloatProperty, BoolProperty, EnumProperty
from bpy.types import Menu,Operator, PropertyGroup

class normal_submenu(Menu):
    bl_label = 'normal tools'
    bl_idname = 'nd9h.abt_normal_subpiemenu'
    def draw(self, context):
        layout = self.layout
        layout.operator("nd9h.abt_flat_face_normal",icon="NORMALS_FACE")
        layout.operator("nd9h.abt_auto_weighted_normal",icon="MOD_NORMALEDIT")
        layout.operator("nd9h.abt_clr_custome_nrm",icon="X")

class meshtool_submenu(Menu):
    bl_label = 'mesh tools'
    bl_idname = 'nd9h.abt_meshtool_subpiemenu'
    def draw(self, context):
        layout = self.layout
        layout.operator("nd9h.abt_clean_mesh",icon="BRUSH_DATA")
        layout.operator("nd9h.abt_remove_dous",icon="SNAP_VERTEX")
        layout.operator("nd9h.abt_select_ngons",icon="SEQ_CHROMA_SCOPE")
        layout.operator("nd9h.abt_select_tris",icon="MESH_DATA")
        layout.operator("nd9h.abt_uvmap",icon="UV") 
        layout.operator("nd9h.checker_deselector",icon="MESH_GRID")
        layout.prop(context.scene.ND9H_ABT, "auto_merge")
        
class shading_submenu(Menu):
    bl_label = 'shading'
    bl_idname = 'nd9h.abt_shading_subpiemenu'
    def draw(self, context):
        layout = self.layout
        col = layout.column(align=True)
        col.operator("nd9h.abt_soildshade",icon = 'SHADING_SOLID')
        col.operator("nd9h.abt_wireshade",icon = 'SHADING_WIRE')    
        col.operator("nd9h.abt_textured_soild_shade",icon = 'SHADING_TEXTURE')
        col.operator(show_obj_wire.bl_idname,icon = 'HIDE_OFF')
        col.operator(hide_obj_wire.bl_idname,icon = 'HIDE_ON')
class modifiers_submenu (Menu):
    bl_label = 'quick modifiers'
    bl_idname = 'nd9h.abt_modifier_subpiemenu'
    def draw(self, context):
        layout = self.layout
        layout.operator("nd9h.abt_applyall",icon='EVENT_RETURN')
        layout.operator("nd9h.abt_deleteall",icon = 'TRASH')
        layout.operator("nd9h.abt_arr_mod_add",icon="MOD_ARRAY")
        layout.operator("nd9h.abt_mirr_mod_add",icon="MOD_MIRROR")
        layout.operator("nd9h.abt_solidify_mod",icon="MOD_SOLIDIFY") 
        layout.operator("nd9h.abt_quick_curve",icon="MOD_CURVE")
class origin_tool (Menu):
    bl_label = 'Origin Transform'
    bl_idname = 'nd9h.abt_origin_subpiemenu'
    def draw(self,context):
        layout = self.layout
        layout.operator(origin2Selected.bl_idname,icon='LAYER_ACTIVE') 
        layout.prop(context.scene.ND9H_ABT, "origin_tran_mode")
class MainPieMenu(Menu):
    bl_label = "ND9H-Advanced Boolean Tool" 
    bl_idname="ABT_OT_menu"
    bl_options = {'REGISTER', 'UNDO'}
    def draw(self,context):
        layout = self.layout
        pie = layout.menu_pie()
        box_preview = pie.box().column_flow(columns=3, align=False)
        box_preview.scale_x=1.7
        box_preview.label(text='Bevel preview')
        box_preview.label(text='Manual Bevel')
        box_preview.operator("nd9h.abt_close_preview_bevel",icon="HIDE_ON")
        box_preview.operator("nd9h.abt_close_manual_preview_bevel",icon="HIDE_ON")  
        box_preview.operator("nd9h.abt_preview_bevel",icon="HIDE_OFF")
        box_preview.operator("nd9h.abt_manual_bevel_preview",icon="HIDE_OFF")
        #box_preview==================================================
       
        #box_main==================================================
        box_main = pie.box().column_flow(columns=2, align=True)
        box_main.scale_x=2
        box_main.label(text='Bevel')
        box_main.operator("nd9h.abt_set_sharp",icon="EDGESEL")
        box_main.operator("nd9h.abt_clear_sharp",icon="X")
        box_main.operator("nd9h.abt_sharpen",icon="EVENT_A")
        box_main.operator("nd9h.abt_bevel_thickness",icon="EVENT_T")
        box_main.operator("nd9h.abt_bevel_size_adjust",icon="TOOL_SETTINGS")
        box_main.separator()
        box_main.label(text='Boolean')
        box_main.operator("nd9h.abt_cutinop", icon='SELECT_SUBTRACT')
        box_main.operator("nd9h.abt_sliceop", icon='MOD_BOOLEAN')
        box_main.operator("nd9h.abt_unionop", icon='SELECT_EXTEND')
        box_main.operator("nd9h.abt_cube_boolean",icon="MOD_WIREFRAME")
        box_main.operator("nd9h.abt_hard_bevel",icon="MOD_BEVEL")
        
        #box_main==================================================
        pie.menu(modifiers_submenu.bl_idname) 
        pie.menu(shading_submenu.bl_idname)
        pie.menu(normal_submenu.bl_idname)

        box3 = pie.box().column_flow(columns=2, align=False)
        pie.menu(meshtool_submenu.bl_idname)
        pie.menu(origin_tool.bl_idname)

        
#=======================================
#FUNCTIONS
#=======================================
def obj_array_for_boolean_get():
    obj_array=[]
    selected_obj = bpy.context.selected_objects
    scene = bpy.context.scene
    active_object = bpy.context.view_layer.objects.active
    for obj in selected_obj:
        obj_array.append(obj.name)
    obj_array.remove(active_object.name)
    print (obj_array)
    return(obj_array)

def selected_object_get():
    obj_array=[]
    selected_obj = bpy.context.selected_objects
    for obj in selected_obj:
        obj_array.append(obj.name)     
    print (obj_array)
    return(obj_array)

def active_object_get():
    active_object = bpy.context.view_layer.objects.active
    return (active_object)
    
def create_bevel_preview_mod():
    obj_array= selected_object_get()
    for item in obj_array:
        bpy.context.view_layer.objects.active=bpy.data.objects[item]
        active_object=bpy.context.view_layer.objects.active
        bevel_mod = active_object.modifiers.new("BV_preview","BEVEL")
        bevel_mod.limit_method = 'ANGLE'
        bevel_mod.angle_limit=0.523599
        bevel_mod.offset_type='WIDTH'
        bevel_mod.harden_normals = True
        bevel_mod.segments=3
        bevel_mod.use_clamp_overlap = False
#WIP
def set_bevel_preview_to_angle_mode():     
    obj = bpy.context.object
    for modifier in obj.modifiers:
        if modifier.name == "BV_preview":  
            modifier.limit_method = 'ANGLE'  
            bpy.ops.object.modifier_move_down(modifier="BV_preview")
          
def create_H_edge_bevel_mod():
    obj_array= selected_object_get()
    for item in obj_array:
        bpy.context.view_layer.objects.active=bpy.data.objects[item]
        active_object = bpy.context.view_layer.objects.active
        obj = bpy.context.object
        obj_array = selected_object_get()
        for modifier in obj.modifiers:
            if modifier.name == "BV_preview":
                modifier.limit_method = 'WEIGHT'
                modifier.use_clamp_overlap = False
                modifier.harden_normals = True
                modifier.offset_type='WIDTH'
                bpy.context.view_layer.objects.active=bpy.data.objects[item]

def different_boolean():
    active_object = active_object_get()
    obj_array = obj_array_for_boolean_get()
    for item in obj_array:
        bpy.ops.object.shade_smooth()
        boolean_mod = active_object.modifiers.new(str(item+"_B"),"BOOLEAN")
        boolean_mod.operation = 'DIFFERENCE'
        boolean_mod.object = bpy.data.objects[item]
        try:
            set_bevel_preview_to_angle_mode()
        except Exception:
            pass
        bpy.context.object.data.use_auto_smooth = True
        bpy.context.view_layer.objects.active=bpy.data.objects[item]
        bpy.context.object.display_type = 'WIRE'

def slice_boolean():
    active_object = active_object_get()
    obj_array = obj_array_for_boolean_get()
    for item in obj_array:
        print(item)
        bpy.ops.object.shade_smooth()
        boolean_mod = active_object.modifiers.new(str(item+"_B"),"BOOLEAN")
        boolean_mod.operation = 'DIFFERENCE'
        boolean_mod.object = bpy.data.objects[item]
        try:
            set_bevel_preview_to_angle_mode()
        except Exception:
            pass
        bpy.context.object.data.use_auto_smooth = True
        bpy.context.view_layer.objects.active=bpy.data.objects[item]
        bpy.context.object.display_type = 'WIRE'       
        bpy.ops.object.modifier_add(type='SOLIDIFY')
        bpy.context.object.modifiers["Solidify"].thickness = 0.0001

def union_boolean():
    active_object = active_object_get()
    obj_array = obj_array_for_boolean_get()
    for item in obj_array:
        print(item)
        bpy.ops.object.shade_smooth()
        boolean_mod = active_object.modifiers.new(str(item+"_B"),"BOOLEAN")
        boolean_mod.operation = 'UNION'
        boolean_mod.object = bpy.data.objects[item]
        try:
            set_bevel_preview_to_angle_mode()   
        except Exception:
            pass
        bpy.context.object.data.use_auto_smooth = True
        bpy.context.view_layer.objects.active=bpy.data.objects[item]
        bpy.context.object.display_type = 'WIRE'

def set_sharpp():
    bpy.ops.mesh.mark_sharp()
    bpy.ops.mesh.mark_seam(clear=False)
    bpy.ops.transform.edge_bevelweight(value=1)
    
def clear_sharp():
    bpy.ops.mesh.mark_sharp(clear=True)
    bpy.ops.mesh.mark_seam(clear=True)
    bpy.ops.transform.edge_bevelweight(value=0)
    
def auto_UV():
    scene=bpy.context.scene
    current_mode = bpy.context.object.mode
    if current_mode == ('OBJECT'): 
        bpy.ops.object.mode_set(mode='EDIT')
        nd9h_auto_sharp()
        bpy.ops.mesh.select_all(action='SELECT')
        bpy.ops.uv.smart_project(angle_limit=89, island_margin=0.01, stretch_to_bounds=False)
        bpy.ops.object.mode_set(mode='OBJECT')
    if current_mode == ('EDIT'):     
        nd9h_auto_sharp()
        bpy.ops.mesh.select_all(action='SELECT')
        bpy.ops.uv.smart_project(angle_limit=89, island_margin=0.01, stretch_to_bounds=False)
        
def soid():
    obj_array = selected_object_get()
    for obj in obj_array:
        bpy.context.view_layer.objects.active=bpy.data.objects[obj]
        bpy.context.object.display_type = 'SOLID'
        bpy.context.object.show_wire = False
        bpy.context.object.show_all_edges = False
    return{'FINISHED'}

def wire():
    obj_array = selected_object_get()
    for item in obj_array:
        bpy.context.view_layer.objects.active=bpy.data.objects[item]
        bpy.context.object.display_type = 'WIRE'
        bpy.context.object.show_wire = True
        bpy.context.object.show_all_edges = True
    return{'FINISHED'}

def textured_soild():
    for item in bpy.context.selected_objects:
        bpy.context.view_layer.objects.active=bpy.data.objects[item.name]
        bpy.context.object.display_type = 'TEXTURED'
        bpy.context.object.show_wire = False
        bpy.context.object.show_all_edges = False
                         
def nd9h_auto_sharp():
    obj_array = selected_object_get()
    bpy.ops.mesh.select_mode(type="EDGE")
    for item in obj_array:
        bpy.context.view_layer.objects.active=bpy.data.objects[item]   
        bpy.ops.mesh.select_all(action='SELECT')
        bpy.ops.mesh.faces_shade_smooth()
        bpy.ops.mesh.select_all(action='DESELECT')
        bpy.ops.mesh.edges_select_sharp(sharpness=1.0472)
        bpy.ops.mesh.mark_sharp()
        bpy.ops.mesh.mark_seam(clear=False)
        bpy.ops.transform.edge_bevelweight(value=1)
        bpy.context.object.data.use_auto_smooth = True
        bpy.context.object.data.auto_smooth_angle = 1.0472

def bake_booleans():
    selected_obj = bpy.context.selected_objects
    for obj in selected_obj:
        bpy.context.view_layer.objects.active=bpy.data.objects[obj.name]
        obj_mods=bpy.context.object.modifiers
        for mods in obj_mods:
            try:
                if search("_B",mods.name):
                    bpy.ops.object.modifier_apply(apply_as='DATA', modifier=(mods.name))
            except RuntimeError:
                bpy.ops.object.modifier_remove(modifier=mods.name)
  
def mirror_mod():
    selected_obj = bpy.context.selected_objects
    for obj_n in selected_obj:
        active_object=bpy.context.view_layer.objects.active
        bpy.context.view_layer.objects.active=bpy.data.objects[obj_n.name]
        arr_mod = active_object.modifiers.new( str(obj_n)+"_Mirr","MIRROR") 
        
def weighted_normal():
    selected_obj = bpy.context.selected_objects
    for obj_n in selected_obj:
        active_object=bpy.context.view_layer.objects.active
        bpy.context.view_layer.objects.active=bpy.data.objects[obj_n.name]
        weighted_nrm_mod = active_object.modifiers.new("Weighted Normal","WEIGHTED_NORMAL")
        bpy.context.object.data.use_auto_smooth = True
        weighted_nrm_mod.weight=100
        weighted_nrm_mod.thresh = 0.01
        weighted_nrm_mod.face_influence = True
    bpy.ops.object.modifier_apply(apply_as='DATA', modifier="Weighted Normal")
    
#draw text function
def draw_text_modal(self,context, x, y,text_string,dynamic_value_bool=False,dynamic_value_name=''): #self, context, text position x, text position y, dynamic value bool
    font_id = 0  # XXX, need to find out how best to get this.
    # draw some text
    blf.position(font_id, x, y, 0)
    blf.size(font_id, 20, 72)
    if dynamic_value_bool == True:
        arg=" blf.draw(font_id, text_string + str("+dynamic_value_name+"))"
        eval(arg)
    else:
        blf.draw(font_id, text_string)

def auto_merge_bool(self, context):
    if bpy.context.scene.ND9H_ABT.auto_merge == True:
        bpy.context.scene.tool_settings.use_mesh_automerge = True
        bpy.context.scene.tool_settings.double_threshold = 0.0001
    else:
        bpy.context.scene.tool_settings.use_mesh_automerge = False

        
def bevel_preview_bool(self,context):
    if bpy.context.scene.ND9H_ABT.preview_bevel == True:
        bpy.context.scene.ND9H_ABT.manual_bevel = False
        obj = bpy.context.object
        bevelmod=False
        obj_array = selected_object_get()
        for modifier in obj.modifiers:
            if modifier.name == "BV_preview":
                bevelmod=True     
                modifier.limit_method = 'ANGLE'
                modifier.angle_limit=0.523599
                modifier.offset_type='WIDTH'
                modifier.harden_normals = True
                modifier.segments=3
                modifier.use_clamp_overlap = False        
                bpy.ops.object.modifier_move_down(modifier="BV_preview")
                bevel_preview = True
            else:
                bevelmod=False
        if bevelmod==True:
            for item in obj_array:
                bpy.context.view_layer.objects.active=bpy.data.objects[item]
                bpy.context.object.modifiers["BV_preview"].show_viewport = True
        if bevelmod==False:
            create_bevel_preview_mod()  
    else:
        obj_array = selected_object_get()
        for item in obj_array:
            try:
                bpy.context.view_layer.objects.active=bpy.data.objects[item]
                bpy.context.object.modifiers["BV_preview"].show_viewport = False
            except KeyError:
                self.report({'INFO'}, 'YOU MUST TURN ON PREVIEW MODE FIRST')   
                           
def manual_bevel_preview_bool(self,context):
    if bpy.context.scene.ND9H_ABT.manual_bevel == True:
        bpy.context.scene.ND9H_ABT.preview_bevel = False
        obj = bpy.context.object
        bevelmod=False
        obj_array = selected_object_get()
        for modifier in obj.modifiers:
            if modifier.name == "BV_preview":
                bevelmod=True     
                modifier.limit_method = 'WEIGHT'
                modifier.angle_limit=0.523599
                modifier.offset_type='WIDTH'
                modifier.harden_normals = True
                modifier.segments=3
                modifier.use_clamp_overlap = False        
                bpy.ops.object.modifier_move_down(modifier="BV_preview")
                bevel_preview = True
            else:
                bevelmod=False
        if bevelmod==True:
            for item in obj_array:
                bpy.context.view_layer.objects.active=bpy.data.objects[item]
                bpy.context.object.modifiers["BV_preview"].show_viewport = True
        if bevelmod==False:
            create_H_edge_bevel_mod()  
    else:
        obj_array = selected_object_get()
        for item in obj_array:
            try:
                bpy.context.view_layer.objects.active=bpy.data.objects[item]
                bpy.context.object.modifiers["BV_preview"].show_viewport = False
            except KeyError:
                self.report({'INFO'}, 'YOU MUST TURN ON PREVIEW MODE FIRST') 
                
def origin_2_selected():
    start_cursor_location_x = bpy.context.scene.cursor.location[0]
    start_cursor_location_y = bpy.context.scene.cursor.location[1]
    start_cursor_location_z = bpy.context.scene.cursor.location[2]
    current_mode = bpy.context.object.mode
    for window in bpy.context.window_manager.windows:
        screen = window.screen
        for area in screen.areas:
            if area.type == 'VIEW_3D':
                override = {'window': window, 'screen': screen, 'area': area}
                if current_mode == 'EDIT':
                    bpy.ops.view3d.snap_cursor_to_selected(override)
                    bpy.ops.object.mode_set(mode='OBJECT')
                    bpy.ops.object.origin_set(type='ORIGIN_CURSOR')
                    bpy.context.scene.cursor.location = (start_cursor_location_x, start_cursor_location_y, start_cursor_location_z)
                    bpy.ops.object.mode_set(mode='EDIT') 
                if current_mode == 'OBJECT':
                    bpy.ops.view3d.snap_cursor_to_selected(override)
                    bpy.ops.object.origin_set(type='ORIGIN_CURSOR')
                    bpy.context.scene.cursor.location = (start_cursor_location_x, start_cursor_location_y, start_cursor_location_z)
                break   
            
def origin_trans_bool (self, context):
    if bpy.context.scene.ND9H_ABT.origin_tran_mode == True:
        bpy.context.scene.tool_settings.use_transform_data_origin = True
    else:
        bpy.context.scene.tool_settings.use_transform_data_origin = False
#=======================================
#classes, buttons
#=======================================
class diffrnt_ops (Operator):
    bl_label = "Different"
    bl_idname = "nd9h.abt_cutinop"
    bl_description = "Different boolean" 
    @classmethod
    def poll( cls, context):
        #return context.objec is not None
        selected_objs = selected_object_get()
        return len(selected_objs) >= 2
    
    def execute(self,context):
        different_boolean()
        return {'FINISHED'}
    
class Slice_ops(Operator):
    bl_idname="nd9h.abt_sliceop"
    bl_label="Slice"
    bl_description = "Slice boolean" 
    @classmethod
    def poll( cls, context):
        #return context.objec is not None
        selected_objs = selected_object_get()
        return len(selected_objs) >= 2
    
    def execute(self,context):
        slice_boolean()
        return{'FINISHED'}
    
class Union_ops(Operator):
    bl_idname="nd9h.abt_unionop"
    bl_label="Union"
    bl_description = "Union boolean" 
    @classmethod
    def poll( cls, context):
        #return context.objec is not None
        selected_objs = selected_object_get()
        return len(selected_objs) >= 2
    
    def execute(self,context):
        union_boolean()
        return{'FINISHED'}
        
class UV_unwrap (Operator):
    bl_idname="nd9h.abt_uvmap"
    bl_label="Auto UV"
    bl_description = "Auto UV Unwrap" 
    def execute(self,context):
        auto_UV()
        self.report({'INFO'}, 'FINISHED')
        return{'FINISHED'}

class soild_shade (Operator):
    bl_idname="nd9h.abt_soildshade"
    bl_label="Soild Shade"
    bl_description = "soild shader" 
    def execute(self,context):
        soid()
        return{'FINISHED'}
    
class wire_shade (Operator):
    bl_idname="nd9h.abt_wireshade"
    bl_label="Wire Shade"
    bl_description = "wire shader" 
    def execute(self,context):
        wire()
        return{'FINISHED'}

class textured_soild_shade (Operator):
    bl_idname="nd9h.abt_textured_soild_shade"
    bl_label = "Textured Soild"
    bl_description="view port textured shading"
    def execute(self,context):
        textured_soild()
        return{'FINISHED'}

class show_obj_wire (Operator):
    bl_idname="nd9h.abt_show_wire"
    bl_label = "Show Wire"
    bl_description="show object's wire"
    def execute(self,context):
        for obj in bpy.context.selected_objects:
            #show wire
            bpy.context.view_layer.objects.active=bpy.data.objects[obj.name]
            bpy.context.object.show_wire = True
            bpy.context.object.show_all_edges = True
        return{'FINISHED'}  

class hide_obj_wire(Operator):
    bl_idname="nd9h.abt_hide_wire"
    bl_label = "Hide Wire"
    bl_description="hide object's wire"
    def execute(self,context):
        for obj in bpy.context.selected_objects:
            #hide wire
            bpy.context.view_layer.objects.active=bpy.data.objects[obj.name]
            bpy.context.object.show_wire = False
            bpy.context.object.show_all_edges = False
        return{'FINISHED'}      
#==================================================================    
#==================================================================   
#==================================================================   
class mirr_mod (Operator):
    bl_idname="nd9h.abt_mirr_mod_add"
    bl_label= "Mirror"
    bl_description="quick mirror modifier"
    def modal(self, context, event):
        context.area.tag_redraw()        
        if event.type == 'LEFTMOUSE':  # Confirm
            #remove text handle
            bpy.types.SpaceView3D.draw_handler_remove(self._handle, 'WINDOW')
            bpy.types.SpaceView3D.draw_handler_remove(self._handle1, 'WINDOW')
            return {'FINISHED'}
        if event.type in {'RIGHTMOUSE', 'ESC'}:  # Cancel 
            #remove text handlZ
            bpy.types.SpaceView3D.draw_handler_remove(self._handle, 'WINDOW')
            bpy.types.SpaceView3D.draw_handler_remove(self._handle1, 'WINDOW')
            return {'CANCELLED'}
        
        elif event.type == 'X':
            bpy.context.object.modifiers[self.mirrmod_name].use_axis[0] = True
            bpy.context.object.modifiers[self.mirrmod_name].use_axis[1] = False
            bpy.context.object.modifiers[self.mirrmod_name].use_axis[2] = False
            self.mirror_axis = 'X'
        elif event.type == 'Y':
            bpy.context.object.modifiers[self.mirrmod_name].use_axis[0] = False
            bpy.context.object.modifiers[self.mirrmod_name].use_axis[1] = True
            bpy.context.object.modifiers[self.mirrmod_name].use_axis[2] = False
            self.mirror_axis = 'Y'
        elif event.type == 'Z':
            bpy.context.object.modifiers[self.mirrmod_name].use_axis[0] = False
            bpy.context.object.modifiers[self.mirrmod_name].use_axis[1] = False
            bpy.context.object.modifiers[self.mirrmod_name].use_axis[2] = True
            self.mirror_axis = 'Z'
        return {'RUNNING_MODAL'}
    def invoke(self, context, event):
        active_object=bpy.context.view_layer.objects.active
        try:
            bpy.context.object.modifiers[str(active_object.name)+"_Mirr"].name
        except KeyError:
            mirr_mod = active_object.modifiers.new( str(active_object.name)+"_Mirr","MIRROR")
            
        self.mirrmod_name =str(active_object.name)+"_Mirr"
        #values
        #dynamic values to display
        self.mirror_axis = 'X'
        bpy.context.object.modifiers[self.mirrmod_name].use_axis[0] = True
        args0 = (self,context, 20,90,"mirror axis (X,Y,Z) :",True,'self.mirror_axis') 
        args1 = (self,context, 20,60,"confirm : (LMB)",False,None) 
        args2 = (self,context, 20,30,"cancel : (RMB)",False,None) 
        self._handle = bpy.types.SpaceView3D.draw_handler_add(draw_text_modal, (args0), 'WINDOW', 'POST_PIXEL')
        self._handle1 = bpy.types.SpaceView3D.draw_handler_add(draw_text_modal, (args1), 'WINDOW', 'POST_PIXEL')
        self._handle = bpy.types.SpaceView3D.draw_handler_add(draw_text_modal, (args2), 'WINDOW', 'POST_PIXEL')
        context.window_manager.modal_handler_add(self)
        return {'RUNNING_MODAL'}
#==================================================================   
#==================================================================   
#==================================================================   
    
class auto_weighted_normal(Operator):
    bl_idname="nd9h.abt_auto_weighted_normal"
    bl_label= "auto weight normal"
    bl_description="auto weight normal mesh"
    def execute(self,context):
        weighted_normal()
        return{'FINISHED'}   
    
#draw text function for modal array
def draw_text_modal_array(self,context, x, y,text_string,dynamic_value_bool=False,dynamic_value_name=''): #self, context, text position x, text position y, dynamic value bool
    font_id = 0  
    blf.position(font_id, x, y, 0)
    blf.size(font_id, 20, 72)
    if dynamic_value_bool == True:
        arg=" blf.draw(font_id, text_string + str("+dynamic_value_name+"))"
        eval(arg)
    else:
        blf.draw(font_id, text_string)
        
class arr_mod (Operator):
    bl_idname="nd9h.abt_arr_mod_add"
    bl_label= "Array"
    bl_description="quick array modifier"
    bl_options = {'REGISTER', 'UNDO'}
    start_count:IntProperty()
    start_value_x:FloatProperty()
    start_value_y:FloatProperty()
    start_value_z:FloatProperty()
    def modal(self, context, event):
        context.area.tag_redraw()
        if event.type == 'MOUSEMOVE':  # Apply
            self.mouse_value = event.mouse_x/500 if event.shift else event.mouse_x/100

            if self.x:
                bpy.context.object.modifiers[self.arrmod_name].constant_offset_displace[0] = self.mouse_value
                bpy.context.object.modifiers[self.arrmod_name].constant_offset_displace[1] = 0
                bpy.context.object.modifiers[self.arrmod_name].constant_offset_displace[2] = 0
                self.array_axis = 'X'
                self.offset_value = round(bpy.context.object.modifiers[self.arrmod_name].constant_offset_displace[0], 3)#round up float number https://www.programiz.com/python-programming/methods/built-in/round
            if self.y:
                bpy.context.object.modifiers[self.arrmod_name].constant_offset_displace[0] = 0
                bpy.context.object.modifiers[self.arrmod_name].constant_offset_displace[1] = self.mouse_value
                bpy.context.object.modifiers[self.arrmod_name].constant_offset_displace[2] = 0
                self.array_axis = 'Y'
                self.offset_value = round(bpy.context.object.modifiers[self.arrmod_name].constant_offset_displace[1], 3)
            if self.z:
                bpy.context.object.modifiers[self.arrmod_name].constant_offset_displace[0] = 0
                bpy.context.object.modifiers[self.arrmod_name].constant_offset_displace[1] = 0
                bpy.context.object.modifiers[self.arrmod_name].constant_offset_displace[2] = self.mouse_value
                self.array_axis = 'Z'
                self.offset_value = round(bpy.context.object.modifiers[self.arrmod_name].constant_offset_displace[2], 3)
            return{'RUNNING_MODAL'}
        if event.type == 'WHEELUPMOUSE':
            bpy.context.object.modifiers[self.arrmod_name].count+=1
            self.dynamic_value = bpy.context.object.modifiers[self.arrmod_name].count
        if event.type == 'WHEELDOWNMOUSE':
            bpy.context.object.modifiers[self.arrmod_name].count-=1
            self.dynamic_value = bpy.context.object.modifiers[self.arrmod_name].count
        elif event.type == 'LEFTMOUSE':  # Confirm
            #remove text handle
            bpy.types.SpaceView3D.draw_handler_remove(self._handle, 'WINDOW')
            bpy.types.SpaceView3D.draw_handler_remove(self._handle1, 'WINDOW')
            bpy.types.SpaceView3D.draw_handler_remove(self._handle0, 'WINDOW')
            return {'FINISHED'}
        elif event.type in {'RIGHTMOUSE', 'ESC'}:  # Cancel 
            #set first value of the modifier 
            bpy.context.object.modifiers[self.arrmod_name].count = self.start_count
            bpy.context.object.modifiers[self.arrmod_name].constant_offset_displace[0] = self.start_value_x
            bpy.context.object.modifiers[self.arrmod_name].constant_offset_displace[1] = self.start_value_y
            bpy.context.object.modifiers[self.arrmod_name].constant_offset_displace[2] = self.start_value_z
            #remove text handlZ
            bpy.types.SpaceView3D.draw_handler_remove(self._handle, 'WINDOW')
            bpy.types.SpaceView3D.draw_handler_remove(self._handle1, 'WINDOW')
            bpy.types.SpaceView3D.draw_handler_remove(self._handle0, 'WINDOW')
            return {'CANCELLED'}
        elif event.type == 'X':
            self.x = True
            self.y = False
            self.z = False
        elif event.type == 'Y':
            self.x = False
            self.y = True
            self.z = False
        elif event.type == 'Z':
            self.x = False
            self.y = False
            self.z = True
        return {'RUNNING_MODAL'}
    def invoke(self, context, event):
        active_object=bpy.context.view_layer.objects.active
        try:
            bpy.context.object.modifiers[str(active_object.name)+"_Arr"].name
        except KeyError:
            arr_mod = active_object.modifiers.new( str(active_object.name)+"_Arr","ARRAY")
            arr_mod.use_relative_offset = False
            arr_mod.use_constant_offset = True
        self.arrmod_name =str(active_object.name)+"_Arr"
        #values
        self.x = True
        self.y = False
        self.z = False
        #dynamic values to display
        self.mouse_value = event.mouse_x
        self.dynamic_value = 0
        self.array_axis = ''
        self.offset_value=0.0
        #dynamic values
        self.start_count = bpy.context.object.modifiers[str(active_object.name)+"_Arr"].count
        self.start_value_x = bpy.context.object.modifiers[self.arrmod_name].constant_offset_displace[0]
        self.start_value_y = bpy.context.object.modifiers[self.arrmod_name].constant_offset_displace[1]
        self.start_value_z = bpy.context.object.modifiers[self.arrmod_name].constant_offset_displace[2]
        #handling drawing text
        #arguments 
        args0 = (self,context, 20,30,"offset: ",True,'self.offset_value') 
        args1 = (self,context, 20,60,"array axis (x,y,z): ",True,'self.array_axis') 
        args2 = (self,context, 20,90,"array segment (mouse wheel): ",True,'self.dynamic_value')
        self._handle0 = bpy.types.SpaceView3D.draw_handler_add(draw_text_modal, (args0), 'WINDOW', 'POST_PIXEL')
        self._handle = bpy.types.SpaceView3D.draw_handler_add(draw_text_modal,  (args1), 'WINDOW', 'POST_PIXEL')
        self._handle1 = bpy.types.SpaceView3D.draw_handler_add(draw_text_modal, (args2), 'WINDOW', 'POST_PIXEL')
        context.window_manager.modal_handler_add(self)
        return {'RUNNING_MODAL'}    
    
class apply_all_mods (Operator):
    bl_idname="nd9h.abt_applyall"
    bl_label="Apply All Modifiers"
    bl_description="Applay all modifiers at once"
    def execute(self,context):
        obj_array=[]
        selected_obj = bpy.context.selected_objects
        for obj in selected_obj:
            bpy.context.view_layer.objects.active=bpy.data.objects[obj.name]
            obj_mods=bpy.context.object.modifiers
            for mods in obj_mods:
                try:
                    bpy.ops.object.modifier_apply(apply_as='DATA', modifier=mods.name)
                except RuntimeError:
                    bpy.ops.object.modifier_remove(modifier=mods.name)
                    
        self.report({'INFO'}, 'APPLIED ALL MODIFIERS')
        return{'FINISHED'}

class delete_all_mods (Operator):
    bl_idname="nd9h.abt_deleteall"
    bl_label="Delete All Modifiers"
    bl_description="Delete all modifiers at once"
    def execute(self,context):
        obj_array=[]
        selected_obj = bpy.context.selected_objects
        for obj in selected_obj:
            bpy.context.view_layer.objects.active=bpy.data.objects[obj.name]
            obj_mods=bpy.context.object.modifiers
            for mods in obj_mods:
                bpy.ops.object.modifier_remove(modifier=mods.name)
        self.report({'INFO'}, 'DELETED ALL MODIFIERS')
        return{'FINISHED'}
        
class auto_sharp (Operator):
    bl_idname="nd9h.abt_sharpen"
    bl_label="Auto Hard Edge"
    bl_description="Auto Sharp edges for bevel"
    def execute(self,context):
        obj_array=selected_object_get()
        for item in obj_array:
            if (bpy.ops.object.mode_set(mode='EDIT')):
                nd9h_auto_sharp()
            else:
                bpy.ops.object.mode_set(mode='EDIT')
                nd9h_auto_sharp()  
        self.report({'INFO'}, 'FINISHED')    
        return{'FINISHED'}
    
        
class set_sharp (Operator):
    bl_idname="nd9h.abt_set_sharp"
    bl_label="Set Hard Edge"
    bl_description="Set bevel edge"
    def execute(self,context):
        current_mode = bpy.context.object.mode
        if current_mode == ('EDIT'):
            set_sharpp()
        else:
            bpy.ops.object.mode_set(mode='EDIT')
        return{'FINISHED'}
    
class clear_sharp (Operator):
    bl_idname="nd9h.abt_clear_sharp"
    bl_label="Soften Edge"
    bl_description=("Clear bevel edge")
    def execute(self,context):
        current_mode = bpy.context.object.mode
        if current_mode == ('EDIT'):
            bpy.ops.mesh.mark_sharp(clear=True)
            bpy.ops.mesh.mark_seam(clear=True)
            bpy.ops.transform.edge_bevelweight(value=-1)
        else:
            bpy.ops.object.mode_set(mode='EDIT')

        return{'FINISHED'}
    
class clean_mesh (Operator):
    bl_idname="nd9h.abt_clean_mesh"
    bl_label="Clean Up"
    bl_description=("Clean up mesh for bevel")
    def execute(self,context):
        obj_array=[]
        selected_obj=bpy.context.selected_objects
        for obj in selected_obj:
            obj_array.append(obj.name)
        for item in obj_array:
            bpy.context.view_layer.objects.active=bpy.data.objects[item]
            bpy.ops.object.mode_set(mode='EDIT')
            bpy.ops.mesh.dissolve_limited(angle_limit=0.0174533, use_dissolve_boundaries=False, delimit={'SEAM', 'SHARP', 'UV'})
            bpy.ops.mesh.select_all(action='SELECT')
            bpy.ops.mesh.remove_doubles(threshold=0.0001)
            bpy.ops.mesh.delete_loose()
            bpy.ops.object.mode_set(mode='OBJECT')
        self.report({'INFO'}, 'MESH CLEAN UP FINISHED')
        return{'FINISHED'}
            
class bake_boolean(Operator):
    bl_idname="nd9h.abt_apply_and_bevel"
    bl_label="Bake Booleans"
    bl_description=("Apply all boolean modifier then bevel the mesh")
    def execute(self,context):
        bake_booleans()          
        return{'FINISHED'}
    
class select_ngon_face(Operator):
    bl_idname="nd9h.abt_select_ngons"
    bl_label="Select N-gons"
    bl_description=("select all n-gons face in mesh")
    def execute(self,context):
        if (bpy.ops.object.mode_set(mode='EDIT')):
            bpy.ops.mesh.select_face_by_sides(number=4, type='GREATER')
        else:
            bpy.ops.object.mode_set(mode='EDIT')
            bpy.ops.mesh.select_face_by_sides(number=4, type='GREATER')
        return{'FINISHED'}
    
class select_tris_face(Operator):
    bl_idname="nd9h.abt_select_tris"
    bl_label="Select Tris"
    bl_description=("select all tris face in mesh")
    def execute(self,context):
        if (bpy.ops.object.mode_set(mode='EDIT')):
            bpy.ops.mesh.select_face_by_sides(number=3)
        else:
            bpy.ops.object.mode_set(mode='EDIT')
            bpy.ops.mesh.select_face_by_sides(number=3)
        return{'FINISHED'}
    
class flat_face_normal(Operator):
    bl_idname="nd9h.abt_flat_face_normal"
    bl_label="Flat Face Normal"
    bl_description=("Flat selected face normal")
    def execute(self,context):
        current_mode = bpy.context.object.mode
        if current_mode == ('OBJECT'):
            bpy.ops.object.mode_set(mode='EDIT')
            bpy.ops.mesh.set_normals_from_faces()
        if current_mode == ('EDIT'):
            bpy.ops.mesh.set_normals_from_faces()    
        return{'FINISHED'}
    
class hard_bevel (Operator):
    bl_idname="nd9h.abt_hard_bevel"
    bl_label="Bake Boolean"
    bl_description=("Apply all boolean modifier then bevel the mesh")
    def execute(self,context):
        obj = bpy.context.object
        obj_array = selected_object_get()
        current_mode = bpy.context.object.mode
        bevelmod=False
        for modifier in obj.modifiers:
            if modifier.name == "BV_preview":
                bevelmod=True
            else:
                bevelmod=False   
        if bevelmod==True:
            if current_mode == ('EDIT'):
                nd9h_auto_sharp()
                create_H_edge_bevel_mod()
            if current_mode == ('OBJECT'):
                bake_booleans()
                bpy.ops.object.mode_set(mode='EDIT')
                nd9h_auto_sharp()
                create_H_edge_bevel_mod()
                bpy.ops.object.mode_set(mode='OBJECT')   
        if bevelmod==False:
            if current_mode == ('EDIT'):
                nd9h_auto_sharp()
                create_bevel_preview_mod()
                create_H_edge_bevel_mod()
            if current_mode == ('OBJECT'):
                bake_booleans()
                bpy.ops.object.mode_set(mode='EDIT')
                nd9h_auto_sharp()
                create_bevel_preview_mod()
                create_H_edge_bevel_mod()
                bpy.ops.object.mode_set(mode='OBJECT')   
        return{'FINISHED'}
    
class preview_bevel(Operator):
    bl_idname="nd9h.abt_preview_bevel"
    bl_label=""
    bl_options = {"REGISTER", "UNDO"}
    bl_description=("preview the bevel while not apply boolean mods")
    def execute(self,context): 
        obj = bpy.context.object
        bevelmod=False
        obj_array = selected_object_get()
        for modifier in obj.modifiers:
            if modifier.name == "BV_preview":
                bevelmod=True     
                modifier.limit_method = 'ANGLE'
                modifier.angle_limit=0.523599
                modifier.offset_type='WIDTH'
                modifier.harden_normals = True
                modifier.segments=3
                modifier.use_clamp_overlap = False        
                bpy.ops.object.modifier_move_down(modifier="BV_preview")
                bevel_preview = True
            else:
                bevelmod=False
        if bevelmod==True:
            for item in obj_array:
                bpy.context.view_layer.objects.active=bpy.data.objects[item]
                bpy.context.object.modifiers["BV_preview"].show_viewport = True
        if bevelmod==False:
            create_bevel_preview_mod()
        return{'FINISHED'}
class close_preview_bevel(Operator):
    bl_idname="nd9h.abt_close_preview_bevel"
    bl_label=""
    bl_description=("turn off preview bevel")
    start_val=""
    def execute(self,context):
        obj_array = selected_object_get()
        global bevel_preview
        bevel_preview = False
        for item in obj_array:
            try:
                bpy.context.view_layer.objects.active=bpy.data.objects[item]
                bpy.context.object.modifiers["BV_preview"].show_viewport = False
            except KeyError:
                self.report({'INFO'}, 'YOU MUST TURN ON PREVIEW MODE FIRST')
        return{'FINISHED'}
        
class manual_bevel_preview(Operator):
    bl_idname="nd9h.abt_manual_bevel_preview"
    bl_label=""
    bl_options = {"REGISTER", "UNDO"}
    bl_description=("preview the bevel using user's bevel weight data")
    def execute(self,context): 
        obj = bpy.context.object
        bevelmod1=False
        obj_array = selected_object_get()
        for modifier in obj.modifiers:
            if modifier.name == "BV_preview_manual":
                bevelmod1=True     
                modifier.limit_method = 'WEIGHT'
                modifier.angle_limit=0.523599
                modifier.offset_type='WIDTH'
                modifier.harden_normals = True
                modifier.segments=3
                modifier.use_clamp_overlap = False        
                bpy.ops.object.modifier_move_up(modifier="BV_preview_manual")
                bevel_preview = True
            else:
                bevelmod=False
        if bevelmod1==True:
            for item in obj_array:
                bpy.context.view_layer.objects.active=bpy.data.objects[item]
                bpy.context.object.modifiers["BV_preview_manual"].show_viewport = True
        if bevelmod1==False:
            obj_array= selected_object_get()
            for item in obj_array:
                bpy.context.view_layer.objects.active=bpy.data.objects[item]
                active_object=bpy.context.view_layer.objects.active
                bevel_mod = active_object.modifiers.new("BV_preview_manual","BEVEL")
                bevel_mod.limit_method = 'WEIGHT'
                bevel_mod.angle_limit=0.523599
                bevel_mod.offset_type='WIDTH'
                bevel_mod.harden_normals = True
                bevel_mod.segments=3
                bevel_mod.use_clamp_overlap = False
                for modifier in obj.modifiers:
                    bpy.ops.object.modifier_move_up(modifier="BV_preview_manual")
        return{'FINISHED'}
class close_manual_preview_bevel(Operator):
    bl_idname="nd9h.abt_close_manual_preview_bevel"
    bl_label=""
    bl_description=("turn off manual bevel preview")
    start_val=""
    def execute(self,context):
        obj_array = selected_object_get()
        global bevel_preview
        bevel_preview = False
        for item in obj_array:
            try:
                bpy.context.view_layer.objects.active=bpy.data.objects[item]
                bpy.context.object.modifiers["BV_preview_manual"].show_viewport = False
            except KeyError:
                self.report({'INFO'}, 'YOU MUST TURN ON PREVIEW MODE FIRST')
        return{'FINISHED'}    
    
class cube_boolean(Operator):
    bl_idname="nd9h.abt_cube_boolean"
    bl_label="Box boolean"
    bl_description=("create box boolean quickly at the cursor position")
    def modal(self, context, event):
        context.area.tag_redraw()
        if event.type == 'LEFTMOUSE':
            bpy.context.scene.tool_settings.use_snap = self.user_use_snap
            bpy.context.scene.tool_settings.snap_elements = self.user_snap_elements
            bpy.context.scene.tool_settings.use_snap_translate = self.user_use_snap_translate
            bpy.context.scene.tool_settings.use_snap_align_rotation = self.user_use_snap_align_rotation
            bpy.ops.object.modifier_apply(apply_as='DATA', modifier="Solidify")
            #remove text
            bpy.types.SpaceView3D.draw_handler_remove(self._handle, 'WINDOW')
            bpy.types.SpaceView3D.draw_handler_remove(self._handle1, 'WINDOW')
            bpy.types.SpaceView3D.draw_handler_remove(self._handle2, 'WINDOW')
            return{'FINISHED'}
            #return {'RUNNING_MODAL'}
        if event.type == 'MIDDLEMOUSE':
            if self.thickness==False:
                bpy.ops.transform.translate('INVOKE_DEFAULT')
            return{'RUNNING_MODAL'}
        if event.type == 'MOUSEMOVE':
            if self.thickness:
                self.value = event.mouse_region_x /500
                bpy.context.object.modifiers["Solidify"].thickness = self.value
                return{'RUNNING_MODAL'}
        elif event.type == 'RIGHTMOUSE':
            if self.thickness==False:               
                if event.value=="RELEASE":
                    self.thickness=True
                    #create boolean
                    for item in self.obj_array:
                        #print(item)
                        bpy.context.view_layer.objects.active=bpy.data.objects[item]
                        active_object = bpy.context.view_layer.objects.active
                        boolean_mod = active_object.modifiers.new(str(item+"_B")+str(self.boolean_obj_id),"BOOLEAN")
                        boolean_mod.operation = 'DIFFERENCE'
                        boolean_mod.object = bpy.data.objects[str(self.boolean_obj_id)]
                        bpy.context.object.data.use_auto_smooth = True
                    try:
                        bpy.ops.object.modifier_move_down(modifier="BV_preview")
                    except Exception:
                        pass
                    bpy.ops.object.select_all(action='DESELECT')
                    bpy.data.objects[str(self.boolean_obj_id)].select_set(True)
                    bpy.context.view_layer.objects.active = bpy.data.objects[str(self.boolean_obj_id)]
                    return{'RUNNING_MODAL'}
        elif event.type == 'ESC':
            #remove text
            bpy.types.SpaceView3D.draw_handler_remove(self._handle, 'WINDOW')
            bpy.types.SpaceView3D.draw_handler_remove(self._handle1, 'WINDOW')
            bpy.types.SpaceView3D.draw_handler_remove(self._handle2, 'WINDOW')
            return {'CANCELLED'}
        return {'RUNNING_MODAL'}
    def invoke(self, context, event):
        if context.object:
            #boolean value setup
            self.boolean_obj_id = randint(100000, 999999)
            self.obj_array = selected_object_get()
            #setting up values
            self.thickness=False
            self.user_use_snap = bpy.context.scene.tool_settings.use_snap
            self.user_snap_elements = bpy.context.scene.tool_settings.snap_elements
            self.user_use_snap_translate = bpy.context.scene.tool_settings.use_snap_translate
            self.user_use_snap_align_rotation = bpy.context.scene.tool_settings.use_snap_align_rotation
 
            bpy.ops.mesh.primitive_plane_add(enter_editmode=False, size = 0.3,location=(bpy.context.scene.cursor.location))
            new_location = (bpy.context.scene.cursor.location[0],bpy.context.scene.cursor.location[1],bpy.context.scene.cursor.location[2]-0.01)
            bpy.context.scene.cursor.location=new_location
            bpy.context.object.name = str(self.boolean_obj_id)
            bpy.ops.object.origin_set(type='ORIGIN_CURSOR', center='MEDIAN')
            bpy.context.object.display_type = 'WIRE'
            bpy.ops.object.modifier_add(type='SOLIDIFY')                    
            bpy.context.scene.tool_settings.use_snap = True
            bpy.context.scene.tool_settings.use_snap_align_rotation = True
            bpy.context.scene.tool_settings.use_snap_translate = True
            bpy.context.scene.tool_settings.snap_elements = {'FACE'}
            bpy.context.scene.tool_settings.snap_target = 'CENTER'
            context.window_manager.modal_handler_add(self)
            #drawtext
            arg=(self,context,20,30,"scale: press(MMB) + S",False,None)
            arg1=(self,context,20,60,"move and snap: press(MMB)",False,None)
            arg2= (self,context,20,90,"extrude: (RMB)",False,None)
            self._handle = bpy.types.SpaceView3D.draw_handler_add(draw_text_modal,  (arg), 'WINDOW', 'POST_PIXEL')
            self._handle1 = bpy.types.SpaceView3D.draw_handler_add(draw_text_modal,  (arg1), 'WINDOW', 'POST_PIXEL')
            self._handle2 = bpy.types.SpaceView3D.draw_handler_add(draw_text_modal, (arg2), 'WINDOW', 'POST_PIXEL')
            return {'RUNNING_MODAL'}
        else:
            self.report({'WARNING'}, "No active object, could not finish")
            return {'CANCELLED'}

     
class live_bevel_size_adjust(Operator):
    bl_idname="nd9h.abt_bevel_size_adjust"
    bl_label="bevel adjust"
    bl_description=("bevel adjustment")
    #first value of the modifier 
    start_val:FloatProperty() 

    def modal(self, context, event):
        context.area.tag_redraw()
        if event.type == 'MOUSEMOVE': 
            if self.mode == 'preview':
                if event.alt == False:
                    try:
                        self.value = event.mouse_region_x /1300
                        bpy.context.object.modifiers["BV_preview"].width = self.value 
                        self.value = round (self.value,3)
                    except KeyError:
                        create_bevel_preview_mod()
                        self.report({'INFO'}, 'TURN ON THE BEVEL PREVIEW FIRST')
                        return{'FINISHED'}
                if event.alt:
                    self.prof = event.mouse_region_x /1300 
                    bpy.context.object.modifiers["BV_preview"].profile = self.prof
                    self.prof = round(bpy.context.object.modifiers["BV_preview"].profile,3)
            else:
                if event.alt == False:
                    try:
                        self.value = event.mouse_region_x /1300
                        bpy.context.object.modifiers["BV_preview_manual"].width = self.value 
                        self.value = round (self.value,3)
                    except KeyError:
                        self.report({'INFO'}, 'TURN ON THE MANUAL BEVEL PREVIEW FIRST')
                        return{'FINISHED'}
                if event.alt:
                    self.prof = event.mouse_region_x /1300 
                    bpy.context.object.modifiers["BV_preview_manual"].profile = self.prof
                    self.prof = round(bpy.context.object.modifiers["BV_preview_manual"].profile,3)       
                                    
        if event.type == 'Q':
            self.mode = 'manual'
            bpy.context.object.modifiers["BV_preview"].width = self.preview_value
            #self.execute(context)
                                 
        if event.type == 'WHEELUPMOUSE':
            if self.mode == 'preview':
                #bpy.context.object.modifiers["BV_preview"].segments += 1
                bpy.context.object.modifiers["BV_preview"].segments+= 1
                self.segm = bpy.context.object.modifiers["BV_preview"].segments
            else:
                bpy.context.object.modifiers["BV_preview_manual"].segments+= 1
                self.segm = bpy.context.object.modifiers["BV_preview_manual"].segments      
                          
        if event.type == 'WHEELDOWNMOUSE':
            if self.mode == 'preview':
                #bpy.context.object.modifiers["BV_preview"].segments -= 1
                bpy.context.object.modifiers["BV_preview"].segments-= 1
                self.segm = bpy.context.object.modifiers["BV_preview"].segments
            else:
                #bpy.context.object.modifiers["BV_preview"].segments -= 1
                bpy.context.object.modifiers["BV_preview_manual"].segments-= 1
                self.segm = bpy.context.object.modifiers["BV_preview_manual"].segments
                
        elif event.type == 'LEFTMOUSE':  # Confirm
            bpy.types.SpaceView3D.draw_handler_remove(self._handle1, 'WINDOW')
            bpy.types.SpaceView3D.draw_handler_remove(self._handle2, 'WINDOW')
            return {'FINISHED'}
        
        elif event.type in {'RIGHTMOUSE', 'ESC'}:  # Cancel 
            bpy.types.SpaceView3D.draw_handler_remove(self._handle1, 'WINDOW')
            bpy.types.SpaceView3D.draw_handler_remove(self._handle2, 'WINDOW')
            #set first value of the modifier 
            bpy.context.object.modifiers["BV_preview"].width = self.preview_value
            bpy.context.object.modifiers["BV_preview_manual"].width = self.manual_value
            return {'CANCELLED'}
        
        return {'RUNNING_MODAL'}
    
    def invoke(self, context, event):
        try:
            self.value = event.mouse_x
            obj = bpy.context.object
            #get first value of the modifier 
            for modifier in obj.modifiers:
                if modifier.name == "BV_preview_manual":
                    self.manual_value = bpy.context.object.modifiers["BV_preview_manual"].width
                    
                elif modifier.name == "BV_preview":
                    self.preview_value = bpy.context.object.modifiers["BV_preview"].width

            self.segm = 0
            self.prof = 0.0
            self.mode = 'preview'#manual
            context.window_manager.modal_handler_add(self)
            
            args0 = (self,context, 20,30,"Offset: ",True,'self.value') 
            args1 = (self,context, 20,60,"Segments (Mouse Wheel): ",True,'self.segm') 
            args2 = (self,context, 20,90,"Profile: (Alt) ",True,'self.prof') 
            args3 = (self,context, 20,120,"Mode: (Q): ",True,'self.mode') 

            self._handle1 = bpy.types.SpaceView3D.draw_handler_add(draw_text_modal,  (args0), 'WINDOW', 'POST_PIXEL')
            self._handle1 = bpy.types.SpaceView3D.draw_handler_add(draw_text_modal,  (args1), 'WINDOW', 'POST_PIXEL')
            self._handle2 = bpy.types.SpaceView3D.draw_handler_add(draw_text_modal,  (args2), 'WINDOW', 'POST_PIXEL')
            self._handle2 = bpy.types.SpaceView3D.draw_handler_add(draw_text_modal,  (args3), 'WINDOW', 'POST_PIXEL')

        except KeyError:
            self.report({'INFO'}, 'TURN ON THE BEVEL PREVIEW OR BAKE BOOLEAN FIRST')
        except Exception as err:
            self.report({'INFO'}, err)
            pass
        return {'RUNNING_MODAL'}

class bevel_thickness_adjust (Operator):
    bl_idname="nd9h.abt_bevel_thickness"
    bl_label="Bevel weight"
    bl_description=("adjust bevel weight") 
    
    @classmethod
    def poll( cls, context):
        #return context.objec is not None
        return bpy.context.mode == 'EDIT_MESH'
    
    def modal(self, context, event):
        context.area.tag_redraw()
        if event.type == 'MOUSEMOVE':
            print("run")
            return {'RUNNING_MODAL'}
        
        if event.type == 'LEFTMOUSE':  # Confirm
            #remove text
            bpy.types.SpaceView3D.draw_handler_remove(self._handle, 'WINDOW')
            return {'FINISHED'}
        
        if event.type == 'WHEELUPMOUSE':
            bpy.ops.transform.edge_bevelweight(value=+0.1)

        if event.type == 'WHEELDOWNMOUSE':
            bpy.ops.transform.edge_bevelweight(value=-0.1)
            
        if event.type in {'RIGHTMOUSE', 'ESC'}:  # Cancel 
            #remove text
            bpy.types.SpaceView3D.draw_handler_remove(self._handle, 'WINDOW')
            return {'CANCELLED'}
        return {'RUNNING_MODAL'}
    
    def invoke(self, context, event):
        if bpy.ops.object.mode_set(mode="OBJECT"):
            bpy.ops.object.mode_set(mode="EDIT")
        
        context.window_manager.modal_handler_add(self)
        arg = (20,30,'bevel thickness: (wheel mouse)',False,None)
        self._handle = bpy.types.SpaceView3D.draw_handler_add(draw_text_modal,  (arg), 'WINDOW', 'POST_PIXEL')
        return {'RUNNING_MODAL'}

class remove_doubles (Operator):
    bl_idname="nd9h.abt_remove_dous"
    bl_label="Remove Doubles"
    @classmethod
    def poll( cls, context):
        #return context.objec is not None
        return bpy.context.mode == 'EDIT_MESH'
    
    def execute(self,context):
        bpy.ops.mesh.remove_doubles(threshold=0.0001)
        self.report({'INFO'}, "FINISHED")
        return {'FINISHED'}
    
class solidify_mod (Operator):
    bl_idname="nd9h.abt_solidify_mod"
    bl_label="Solidify"
    bl_description=("quick solidify mod") 
    def modal(self, context, event):
        context.area.tag_redraw()
        if event.type == 'LEFTMOUSE':  # Confirm
            bpy.types.SpaceView3D.draw_handler_remove(self._handle, 'WINDOW')
            soid()
            return {'FINISHED'}
        if event.type in {'RIGHTMOUSE', 'ESC'}:  # Cancel 
            return {'CANCELLED'}
        
        if event.type == 'MOUSEMOVE':  # Confirm
            self.value = (event.mouse_x) /250
            if event.shift:
                self.value = event.mouse_region_x /500
                bpy.context.object.modifiers["Solidify"].thickness = self.value
            if event.alt == True:
                self.value = self.value * -1
            bpy.context.object.modifiers["Solidify"].thickness = self.value
            return {'RUNNING_MODAL'}
        return {'RUNNING_MODAL'}
    
    def invoke(self, context, event):
        self.value = event.mouse_x
        bpy.ops.object.modifier_add(type='SOLIDIFY')
        context.window_manager.modal_handler_add(self)
        wire()
        args0 = (self,context, 20,30,"thickness: ",True,'self.value') 
        args1 = (self,context, 20,60,"invert: (Alt) ",False,None) 
        self._handle = bpy.types.SpaceView3D.draw_handler_add(draw_text_modal,  (args0), 'WINDOW', 'POST_PIXEL')
        self._handle = bpy.types.SpaceView3D.draw_handler_add(draw_text_modal,  (args1), 'WINDOW', 'POST_PIXEL')
        return {'RUNNING_MODAL'}
    
class clear_custome_nrm (Operator):
    bl_idname="nd9h.abt_clr_custome_nrm"
    bl_label="clear custom normal"
    bl_description=("clear custom split normal data") 
    def execute(self, context):
        bpy.ops.mesh.customdata_custom_splitnormals_clear()
        self.report({'INFO'}, 'FINISHED')
        return {'FINISHED'}
    
class origin2Selected(Operator):
    bl_idname="nd9h.origin2_selected"
    bl_label="Origin To Selected"
    bl_description=("set object's origin to selected")
    def execute(self,context):
        origin_2_selected()
        return {'FINISHED'}

class quick_curve(Operator):
    bl_idname="nd9h.abt_quick_curve"
    bl_label="Curve"
    bl_description=("add curve modifier to object using active curve path")
    @classmethod
    def poll( cls, context):
        #return context.objec is not None
        active_object = active_object_get()
        return active_object.type == "CURVE"
    
    def execute(self,context):
        active_object = active_object_get()
        selected = selected_object_get()
        obj_array = obj_array_for_boolean_get()
        for obj in obj_array:
            curve_mod = bpy.data.objects[obj].modifiers.new(str(obj+"_Curve"),"CURVE")
            curve_mod.object = bpy.data.objects[active_object.name]
            bpy.ops.view3d.snap_selected_to_active()
            bpy.context.view_layer.objects.active=bpy.data.objects[obj]
        return {'FINISHED'}   
    
class checker_deselector(Operator):
    bl_idname="nd9h.checker_deselector"
    bl_label="Checker deselect"
    bl_description=("modal checler deselect") 
    def modal(self, context, event):
        context.area.tag_redraw()
        if event.type == 'WHEELUPMOUSE':
            
            if event.alt == True:
                self.nth_val+=1 #self.skip_val+=1
            if event.ctrl == True:
                self.offset_val+=1
            if event.alt==False and event.ctrl==False:
                self.skip_val+=1                 

        if event.type == 'WHEELDOWNMOUSE':
              
            if self.skip_val <=1:
                if event.alt == True: 
                    self.nth_val=1 #self.skip_val=1
                    
                if event.ctrl == True:
                    self.offset_val=1   
                
                if event.alt==False and event.ctrl==False:
                    self.skip_val=1
                                                
            else:
                if event.alt == True: 
                    self.nth_val-=1 #self.skip_val-=1

                if event.ctrl == True:
                    self.offset_val-=1
                if event.alt==False and event.ctrl==False:
                    self.skip_val-=1                     

        elif event.type == 'LEFTMOUSE':  # Confirm
            #remove text handle
            bpy.ops.mesh.select_nth(skip=self.skip_val, nth=self.nth_val, offset=self.offset_val)
            bpy.types.SpaceView3D.draw_handler_remove(self._handle, 'WINDOW')
            return {'FINISHED'}
        elif event.type in {'RIGHTMOUSE', 'ESC'}:  # Cancel 
            #remove text handlZ
            bpy.types.SpaceView3D.draw_handler_remove(self._handle, 'WINDOW')
            return {'CANCELLED'}
        return {'RUNNING_MODAL'}
    
    def invoke(self, context, event):
        self.skip_val=1
        self.nth_val=1
        self.offset_val=0
        context.window_manager.modal_handler_add(self)

        args0 = (self,context, 20,30,"skip: (WMB): ",True,'self.skip_val') 
        args1 = (self,context, 20,60,"selected: (WMB+Alt): ",True,'self.nth_val') 
        args2 = (self,context, 20,90,"offset: (WMB+Ctrl): ",True,'self.offset_val')
        args3 = (self,context, 20,120,"confirm: (LMB): ",False,None)
        self._handle = bpy.types.SpaceView3D.draw_handler_add(draw_text_modal,  (args0), 'WINDOW', 'POST_PIXEL')
        self._handle = bpy.types.SpaceView3D.draw_handler_add(draw_text_modal,  (args1), 'WINDOW', 'POST_PIXEL')
        self._handle = bpy.types.SpaceView3D.draw_handler_add(draw_text_modal,  (args2), 'WINDOW', 'POST_PIXEL')
        self._handle = bpy.types.SpaceView3D.draw_handler_add(draw_text_modal,  (args3), 'WINDOW', 'POST_PIXEL')
        return {'RUNNING_MODAL'}
                 
#--------------------------------addon-properties
class ND9H_ABT_properties(PropertyGroup):
    auto_merge = BoolProperty (
        name="Auto Merge",
        description="auto merge duplicates",
        default= False, 
        update = auto_merge_bool,
        )
    preview_bevel = BoolProperty (
        name="Auto bevel",
        description="Auto bevel preview using hard angles ",
        default= False,
        update=bevel_preview_bool 
        )
    manual_bevel = BoolProperty (
        name="Manual bevel",
        description="Manual bevel preview using bevel weight",
        default= False,
        update=manual_bevel_preview_bool 
        )
        
    origin_tran_mode = BoolProperty (
        name="Origin Transform",
        description="origin transform mode",
        default= False, 
        update = origin_trans_bool,
        )

AddonClasses = (
    MainPieMenu,
    diffrnt_ops,
    Slice_ops,
    Union_ops,
    UV_unwrap,
    soild_shade,
    wire_shade,
    auto_sharp,
    apply_all_mods,
    delete_all_mods,
    set_sharp,
    clear_sharp,
    hard_bevel,
    clean_mesh,
    bevel_thickness_adjust,
    bake_boolean,
    select_ngon_face,
    select_tris_face,
    flat_face_normal,
    preview_bevel,
    close_preview_bevel,
    live_bevel_size_adjust,
    cube_boolean,
    arr_mod,
    mirr_mod,
    solidify_mod,
    auto_weighted_normal,
    remove_doubles,
    shading_submenu,
    modifiers_submenu,
    meshtool_submenu,
    normal_submenu,
    clear_custome_nrm,
    ND9H_ABT_properties,
    textured_soild_shade,
    show_obj_wire,
    hide_obj_wire,
    origin_tool,
    origin2Selected,
    quick_curve,
    manual_bevel_preview,
    close_manual_preview_bevel,
    checker_deselector

)

addon_keymaps = []
def register():
    for cls in AddonClasses:
        bpy.utils.register_class(cls)
             
    # handle the keymap
    wm = bpy.context.window_manager
    km = wm.keyconfigs.addon.keymaps.new(name='3D View', space_type='VIEW_3D')
    kmi = km.keymap_items.new("wm.call_menu_pie", 'X', 'PRESS', alt=True).properties.name = "ABT_OT_menu"
    addon_keymaps.append( (km,kmi) )
    # Bind reference of type of our data block to type Scene objects so that the addon custom properties could work
    bpy.types.Scene.ND9H_ABT = bpy.props.PointerProperty(type=ND9H_ABT_properties) 
def unregister():
    for cls in AddonClasses:
        bpy.utils.unregister_class(cls)
        
    # handle the keymap
    for km,kmi in addon_keymaps:
        #km.keymap_items.remove(kmi)
        wm = bpy.context.window_manager
        wm.keyconfigs.addon.keymaps.remove(km)
    addon_keymaps.clear()    # clear the list
    del bpy.types.Scene.ND9H_ABT
if __name__ == "__main__":
    register()