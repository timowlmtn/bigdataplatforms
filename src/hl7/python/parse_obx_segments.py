from hl7apy import parser
import json


def hl7_str_to_dict(s, use_long_name=True):
    """Convert an HL7 string to a dictionary
    :param s: The input HL7 string
    :param use_long_name: Whether or not to user the long names
                          (e.g. "patient_name" instead of "pid_5")
    :returns: A dictionary representation of the HL7 message
    """
    s = s.replace("\n", "\r")
    m = parser.parse_message(s)
    return hl7_message_to_dict(m, use_long_name=use_long_name)


def hl7_message_to_dict(m, use_long_name=True):
    """Convert an HL7 message to a dictionary
    :param m: The HL7 message as returned by :func:`hl7apy.parser.parse_message`
    :param use_long_name: Whether or not to user the long names
                          (e.g. "patient_name" instead of "pid_5")
    :returns: A dictionary representation of the HL7 message
    """
    if m.children:
        d = {}
        for c in m.children:
            name = str(c.name).lower()
            if use_long_name:
                name = str(c.long_name).lower() if c.long_name else name
            dictified = hl7_message_to_dict(c, use_long_name=use_long_name)
            if name in d:
                if not isinstance(d[name], list):
                    d[name] = [d[name]]
                d[name].append(dictified)
            else:
                d[name] = dictified
        return d
    else:
        return m.to_er7()


with open("data/vxu_v251.hl7") as fin:
    hl7_message = parser.parse_message(fin.read())

with open("data/vxu_v251.json", "w") as file_out:
    file_out.write(json.dumps(hl7_str_to_dict(hl7_message.to_er7()), indent=2))
