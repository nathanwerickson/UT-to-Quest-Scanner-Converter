# Test data:
unique_number = 58335
assignment_title = "MT3_58335_CTL_Output"
timestamp = 131127093952
input_file = "MT3_58335_CTL_File.scn"

#Opens the file and converts it into an array to be parsed
ctlUpload = []
File.read(input_file).each_line do |line|
  ctlUpload << line.chop
end
output_file = File.new("#{assignment_title}.txt", 'w')

#This breaks up the string into the useful pieces
ctlUpload.each do |x|
 
  last_name = x[0..12]
  first_name = x[13..19]
  uteid = x[20..27]
  score = x[33..45]
  version = x[46..51].to_i
  answerstring = x[53..152].to_s
 
#adjusts for version number appearing in different places
  if version < 10
    version_string = "00000" + version.to_s
  elsif version < 100
    version_string = "0000" + version.to_s
  elsif version < 1000
    version_string = "000" + version.to_s
  else
    version_string = version.to_s
  end
 
#This takes the answer string and converts them into Q# and answer string
  counter = 0
  while counter < 99
    mvalue = (counter < 9 ? "m0#{counter + 1}" : "m#{counter + 1}")
    answerchoice = ""
 
    if answerstring[counter] == " "
      achoice = " "
    elsif answerstring[counter] == "?"
	  achoice = "?"
	else
      achoice = answerstring[counter].to_i + 1
      humanachoice = achoice % 10
    end
 
    for j in 1..10
      if achoice == " "
        answerchoice << " "
	  elsif achoice == "?"
	    answerchoice = "1234567890"
      elsif j == achoice
        answerchoice << "#{humanachoice}"
      else
        answerchoice << " "
      end
    end
 
#This writes the lines of code to mimic the Quest upload file.
    if answerchoice != "          "
	  output_file.write("#{uteid}   #{version_string} #{timestamp} #{mvalue} #{answerchoice} m #{last_name}#{first_name}      #{unique_number}\n")
	end
    counter += 1
  end
end
 
output_file.close
puts "Upload file has been created called #{assignment_title}"