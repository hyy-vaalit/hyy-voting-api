module Haka

  # Describes the person entity who is signing in from the Haka federation.
  class Person
    attr_reader :voter

    # Params:
    # - raw_student_number: URN attribute of the Haka entity's student number
    def initialize(raw_student_number)
      student_number = parse_student_number raw_student_number

      @voter = find_voter student_number
    end

    protected

    def find_voter(student_number)
      Voter.find_by_student_number! student_number
    end

    # Parse actual student id from University of Helsinki's format:
    #   urn:mace:terena.org:schac:personalUniqueCode:int:studentID:helsinki.fi:165934
    #
    # See also:
    #   http://www.helsinki.fi/atk/luvat/ldap/doc/index.html#henkiloluokat_schacPersonalUniqueCode
    #   https://confluence.csc.fi/display/HAKA/funetEduPersonSchema2dot2#funetEduPersonSchema2dot2-schacPersonalUniqueCode
    #
    # Returns the number value of the last URN attribute:
    #   raw "urn:schac:personalUniqueCode:fi:yliopisto.fi:x873421"
    #   will return: "873421"
    def parse_student_number(raw)
      raw.split(":").last.delete('^0-9')
    end

  end
end
