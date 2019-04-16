note
	description: "Summary description for {PHASE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PHASE

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
			create phaseid.make_empty
			create name.make_empty
			create capacity.default_create
			create container_count.default_create
			create phase_radiation.default_create
			create containers.make(10)
			create expected_materials.make_empty
			create expected_materials_no.make_empty
		end

feature -- atttributes

	phaseid: STRING
	name: STRING
	capacity: INTEGER_64
	container_count : INTEGER_64
	phase_radiation : VALUE
	expected_materials : ARRAY[STRING]
	expected_materials_no : ARRAY[INTEGER_64]
	containers : HASH_TABLE[PHASE_CONTAINER,STRING]


feature -- queries



feature -- commands

    material_switch (materials: ARRAY[INTEGER_64]) -- to switch the accepted materials to appropriate boolean value for this phase
	    local
	    	count : INTEGER
		do
			count := 0
			across materials as cr loop

				if cr.item = 1 and (not expected_materials_no.has (1)) then expected_materials_no.force(1 ,count) expected_materials.force("glass",count)count:=count+1 end
				if cr.item = 2 and (not expected_materials_no.has (2)) then expected_materials_no.force(2 ,count) expected_materials.force("metal",count) count:=count+1 end
				if  cr.item = 3 and (not expected_materials_no.has (3)) then expected_materials_no.force(3 ,count) expected_materials.force("plastic",count) count:=count+1 end
				if cr.item = 4 and (not expected_materials_no.has (4)) then expected_materials_no.force(4 ,count) expected_materials.force("liquid",count) end
			end
		end

    set_phaseid (a_pid : STRING)
    	do
    		phaseid := a_pid
    	ensure
    		phase_changed : phaseid ~ a_pid
    	end

    set_name (a_name : STRING)
    	do
    		name := a_name
    	ensure
    		name_changed : name ~ a_name
    	end

    set_capacity (a_capacity : INTEGER_64)
    	do
    		capacity := a_capacity
    	ensure
    		cap_changed : capacity = a_capacity
    	end

    add_container_count (a_count : INTEGER_64)
    	do
    		container_count := container_count + a_count
    	ensure
    		count_changed : container_count = old container_count+a_count
    	end

    add_phase_radiation (npr : VALUE)
    	do
    		phase_radiation := phase_radiation + npr
    	ensure
    		phase_rad_changed : phase_radiation = old phase_radiation + npr
    	end

    is_less alias "<" (other: like Current): BOOLEAN
	do
        	Result := Current.phaseid < other.phaseid
	end

invariant
	container_count_not_negative: container_count >= 0
	phase_radiation_not_negative: phase_radiation.is_greater_equal (create {VALUE}.default_create)


end
