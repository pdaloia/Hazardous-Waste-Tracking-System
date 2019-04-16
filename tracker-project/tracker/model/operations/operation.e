note
	description: "Summary description for {OPERATION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	OPERATION
feature
	nuclear_plant: ETF_MODEL
		local
			ma: ETF_MODEL_ACCESS
		once
			Result := ma.m
		end

	stored_message: STRING
		-- operation at the UI: e.g. ok
	stored_counter: INTEGER
		-- counter when created

	execute
		deferred
		end
	undo
		deferred
		end

	redo
		deferred
		end

end
