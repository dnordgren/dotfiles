on performSmartRule(theRecords)
	tell application id "DNtp"
		repeat with theRecord in theRecords
			-- Record's creation date, as date object
			set recordDate to (creation date of theRecord)

			-- Format day
			set recordDay to (day of recordDate) as integer
			if recordDay < 10 then set recordDay to ("0" & recordDay)
			set recordDay to recordDay as string

			-- Format month
			set recordMonth to (month of recordDate) as integer
			if recordMonth < 10 then set recordMonth to ("0" & recordMonth)
			set recordMonth to recordMonth as string

			-- Format year
			set recordYear to (year of recordDate)
			set recordShortYear to (characters 3 thru 4 of (recordYear as string)) as string

			set formattedRecordDate to (recordShortYear & recordMonth & recordDay)

		    set name of theRecord to (formattedRecordDate & " " & (name of theRecord))
		end repeat
	end tell
end performSmartRule
