wizard = {
  "Will this be a public or private cloud?" =>
  [
    {
      text: "Public",
      tags_to_add: ["public"],
      tags_to_remove: ["private"]
    },
    {
      text: "Private",
      tags_to_add: ["private"],
      tags_to_remove: ["public"]
    }
  ],
  "What programming language will be used?" => [
    {
      text: "PHP",
      tags_to_add: ["PHP","Linux"],
      tags_to_remove: ["Windows", "Java", "Ruby", "dotNet"]
    },
    {
      text: "Ruby",
      tags_to_add: ["Linux", "Ruby", "dotNet"],
      tags_to_remove: ["PHP", "Windows", "Java", "dotNet"]
    },
    {
      text: "Java",
      tags_to_add: ["Linux", "Windows", "Java"],
      tags_to_remove: ["PHP", "Ruby", "dotNet"]
    },
    {
      text: "dotNet",
      tags_to_add: ["dotNet", "Windows"],
      tags_to_remove: ["Linux", "Java", "Ruby", "PHP"]
    }
  ],
  "Does this require FedRAMP certification?" =>
  [
    {
      text: "Yes",
      tags_to_add: ["FedRAMP"],
      tags_to_remove: []
    },
    {
      text: "No",
      tags_to_add: [],
      tags_to_remove: ["FedRamp"]
    }
  ],
  "What FISMA Classifaction is needed?" =>
  [
    {
      text: "Low",
      tags_to_add: ["FISMAlow", "FISMAmedium", "FISMAhigh"],
      tags_to_remove: ["FISMAhigh", "NonFISMA"]
    },
    {
      text: "Medium",
      tags_to_add: ["FISMAmedium", "FISMAhigh"],
      tags_to_remove: ["FISMAlow", "NonFISMA"]
    },
    {
      text: "High",
      tags_to_add: ["FISMAhigh"],
      tags_to_remove: ["FISMAlow", "FISMAmedium", "NonFISMA"]
    }
  ],
  "What is your preferred Cloud Provider?" =>
  [
    {
      text: "AWS",
      tags_to_add: ["AWS"],
      tags_to_remove: ["VMware", "Azure"]
    },
    {
      text: "VMWare",
      tags_to_add: ["VMWare"],
      tags_to_remove: ["AWS", "Azure"]
    },
    {
      text: "Azure",
      tags_to_add: ["Azure"],
      tags_to_remove: ["AWS", "VMWare"]
    }
  ],
  "Will you require high availability" =>
  [
    {
      text: "Yes",
      tags_to_add: ["HA"],
      tags_to_remove: []
    },
    {
      text: "No",
      tags_to_add: [],
      tags_to_remove: ["HA"]
    }
  ],
}
wizard.each do |question, answers|
  unless WizardQuestion.find_by(text: question)
    question = WizardQuestion.create(text: question)
    question.wizard_answers.create(answers)
  end
end



# What programming language will be used?
# Answer: PHP -> +PHP +Linux, -Windows, -Java, -Ruby, -dotNet
# Answer: Ruby -> +Ruby +Linux, -Windows, -Java, -PHP, -dotNet
# Answer: Java -> +Java +Linux, +Windows, -PHP, -Ruby, -dotNet
# Answer: dotNet -> +dotNet +Windows, -Linux, -Java, -Ruby, -PHP
#
# Does this require FedRAMP certification?
# Yes: +FedRAMP
# No: -NonFedRAMP
#
# What FISMA Classifaction is needed?
# Low: +FISMAlow, +FISMAmedium, +FISMAhigh, -NonFISMA
# Medium: -FISMAlow, +FISMAmedium, +FISMAhigh, -NonFISMA
# High: -FISMAlow, -FISMAmedium, +FISMAhigh, -NonFISMA
#
# What is your preferred Cloud Provider?
# AWS: +AWS, -VMware, -Azure
# VMware: -AWS, +VMware, -Azure
# Azure: -AWS, -VMware, +Azure
#
# Will you require high availability
# Yes: +HA
# No: -NoHA
