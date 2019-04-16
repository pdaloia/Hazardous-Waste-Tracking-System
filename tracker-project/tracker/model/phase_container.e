note
	description: "Summary description for {PHASE_CONTAINER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PHASE_CONTAINER

inherit
	COMPARABLE
	   redefine
	    is_less
	    end

create
	make

feature
	make
		do
			create cid.make_empty
			create material.default_create
			create radioactivity.default_create
			create current_phaseid.make_empty
		end

feature -- atttributes

	cid : STRING
	material : INTEGER_64
	radioactivity : VALUE
	current_phaseid: STRING


feature -- commands

	set_cid (a_cid: STRING)
		do
			cid := a_cid
		ensure
			cid_changed: cid ~ a_cid
		end

	set_material (a_material: INTEGER_64)
		do
			material := a_material
		ensure
			material_changed: material ~ a_material
		end

	set_radioactivity (a_radioactivity: VALUE)
		do
			radioactivity := a_radioactivity
		ensure
			rad_changed: radioactivity = a_radioactivity
		end

	set_current_phaseid(a_pid: STRING)
		do
			current_phaseid := a_pid
		ensure
			current_phaseid_changed: current_phaseid ~ a_pid
		end

	is_less alias "<" (other: like Current): BOOLEAN
	do
        	Result := Current.cid < other.cid
	end

invariant
	rad_not_negative: radioactivity.is_greater_equal (create {VALUE}.default_create)
	material_valid_range: material <=4 and material >= 0

end
