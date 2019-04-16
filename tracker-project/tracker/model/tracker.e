note
	description: "Summary description for {TRACKER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TRACKER

create
	make

feature {NONE}

	make
		do
			create phases.make(10)
			create max_phase_radiation.default_create
			create max_container_radiation.default_create
			create active_tracker_op.make
			create container_count.default_create
		end

feature -- attributes

	phases : HASH_TABLE[PHASE,STRING]
	tracker_in_use : BOOLEAN
	max_phase_radiation : VALUE
	max_container_radiation : VALUE
	active_tracker_op : NEW_TRACKER
	container_count : INTEGER

feature -- commands

	set_tracker_in_use (tiu : BOOLEAN)
		do
			tracker_in_use := tiu
		ensure
			tracker_use_changed: tracker_in_use = tiu
		end

	set_max_phase_radiation (mpr : VALUE)
		do
			max_phase_radiation := mpr
		ensure
			max_phase_rad_changed:	max_phase_radiation = mpr
		end

	set_max_container_radiation (mcr : VALUE)
		do
			max_container_radiation := mcr
		ensure
			max_container_rad_changed:	max_container_radiation = mcr
		end

	set_active_tracker_op (a_op : NEW_TRACKER)
		do
			active_tracker_op := a_op
		ensure
			active_tracker_op_changed:	active_tracker_op = a_op
		end

feature -- Queries

	get_material(a_val : INTEGER_64) : STRING
		require
			a_val <=4 and a_val >= 1
		do
			if (a_val = 1) then
				Result := "glass"
			elseif (a_val = 2) then
				Result := "metal"
			elseif (a_val = 3) then
				Result := "plastic"
			else
				Result := "liquid"
			end
		ensure
			vaid_material: Result ~ "glass" or Result ~ "metal" or Result ~ "plastic" or Result ~ "liquid"
		end

	has_container (cid : STRING) : BOOLEAN
	do
		Result := false
		across phases as p loop
			across p.item.containers as c loop
				if ( c.item.cid ~ cid) then
					RESULT := True
				end
			end
		end
	end

	no_of_containers : INTEGER
	do
		container_count := 0
		across phases as p loop
			across p.item.containers as c loop
				container_count := container_count + 1
			end
		end
		Result := container_count
	end

	get_current_phaseid (cid : STRING):  STRING
	do
		Result := ""
			across phases as p loop
				across p.item.containers as c loop
					if ( c.item.cid ~ cid) then
						RESULT := c.item.current_phaseid
					end
				end
			end
	end

invariant
	max_phase_rad_not_negative: max_phase_radiation.is_greater_equal (create {VALUE}.default_create)
	max_container_radiation_not_negative: max_container_radiation.is_greater_equal  (create {VALUE}.default_create)
	container_count_not_negative : container_count >=0 
end
