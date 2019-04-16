note
	description: "A default business model."
	author: "Jackie Wang"
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_MODEL

inherit
	ANY
		redefine
			out
		end

create {ETF_MODEL_ACCESS}
	make

feature {NONE} -- Initialization
	make
			-- Initialization for `Current'.
		do
			message := "ok"
			go_to_i := " "
			create s.make_empty
			current_i := 0
			create history.make
			create tracker.make
		end

feature -- messages

	message: STRING
	go_to_i: STRING

	err_success : STRING
     attribute Result := "ok" end

    err_e1 : STRING
     attribute Result := "e1: current tracker is in use" end

    err_e2 : STRING
     attribute Result := "e2: max phase radiation must be non-negative value" end

    err_e3 : STRING
     attribute Result := "e3: max container radiation must be non-negative value" end

    err_e4 : STRING
     attribute Result := "e4: max container must not be more than max phase radiation" end

    err_e5 : STRING
     attribute Result := "e5: identifiers/names must start with A-Z, a-z or 0..9" end

	err_e6 : STRING
     attribute Result := "e6: phase identifier already exists" end

	err_e7 : STRING
     attribute Result := "e7: phase capacity must be a positive integer" end

	err_e8 : STRING
     attribute Result := "e8: there must be at least one expected material for this phase" end

	err_e9 : STRING
     attribute Result := "e9: phase identifier not in the system" end

	err_e10 : STRING
     attribute Result := "e10: this container identifier already in tracker" end

	err_e11 : STRING
     attribute Result := "e11: this container will exceed phase capacity" end

	err_e12 : STRING
     attribute Result := "e12: this container will exceed phase safe radiation" end

	err_e13 : STRING
     attribute Result := "e13: phase does not expect this container material" end

	err_e14 : STRING
     attribute Result := "e14: container radiation capacity exceeded" end

	err_e15 : STRING
     attribute Result := "e15: this container identifier not in tracker" end

	err_e16 : STRING
     attribute Result := "e16: source and target phase identifier must be different" end

	err_e17 : STRING
     attribute Result := "e17: this container identifier is not in the source phase" end

	err_e18 : STRING
     attribute Result := "e18: this container radiation must not be negative" end

    err_e19 : STRING
     attribute Result := "e19: there is no more to undo" end

    err_e20 : STRING
     attribute Result := "e20: there is no more to redo" end


feature -- model attributes

	s : STRING
	current_i : INTEGER

	history: HISTORY
	tracker: TRACKER



feature -- model operations
	default_update
			-- Perform update to the model state.
		do
			current_i := current_i + 1
		end

	reset
			-- Reset model state.
		do
			make
		end

feature -- commands

	set_message(a_message:STRING)
		do
			message := a_message
		ensure
			mess_changed: message ~ a_message
		end

	set_go_to_i(a_message:STRING)
		do
			go_to_i := a_message
		ensure
			i_changed: go_to_i ~ a_message
		end

feature

	out : STRING
		local
			sorted_phases : SORTED_TWO_WAY_LIST[PHASE]
			sorted_containers : SORTED_TWO_WAY_LIST[PHASE_CONTAINER]
		do
            create Result.make_from_string ("  ")
			Result.append ("state " + current_i.out + go_to_i + message )

			if message ~ "ok" then
				create sorted_phases.make
		    	sorted_phases.compare_objects

				create sorted_containers.make
		    	sorted_containers.compare_objects

		    	across tracker.phases as tp
		    		loop
		    			sorted_phases.extend (tp.item)
		    			across tp.item.containers as c loop sorted_containers.extend (c.item)  end
		    		end

				Result.append ("%N  " + "max_phase_radiation: " + tracker.max_phase_radiation.out)
				Result.append (", max_container_radiation: " + tracker.max_container_radiation.out)

				Result.append ("%N  " + "phases: pid->name:capacity,count,radiation")
				across sorted_phases as c
				loop
					Result.append ("%N    " + c.item.phaseid + "->")
					Result.append (c.item.name + ":")
					Result.append (c.item.capacity.out + ",")
					Result.append (c.item.container_count.out + ",")
					Result.append (c.item.phase_radiation.out + ",{")
					across c.item.expected_materials as em
					loop
						Result.append (em.item + ",")
					end
					Result.remove_tail (1)
					Result.append ("}")
				end

				Result.append ("%N  " + "containers: cid->pid->material,radioactivity")
				across sorted_containers as c
				loop
					Result.append ("%N    " + c.item.cid  + "->")
					Result.append (c.item.current_phaseid + "->")
					Result.append (tracker.get_material (c.item.material) + ",")
					Result.append (c.item.radioactivity.out)
				end
			end

		end

end




