# Copyright (C) Nicolas Lamirault <nicolas.lamirault@gmail.com>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

vpc_id = attribute("vpc_id")

portefaix_version = input('portefaix_version')
portefaix_section = 'vpc'

title "VPC standards"

# VPC.1
# =======================================================

portefaix_req = "#{portefaix_section}.1"

control "portefaix-aws-#{portefaix_version}-#{portefaix_req}" do
  title "Ensure that VPC exist and tags correcly set"
  impact 1.0

  tag standard: "portefaix"
  tag portefaix_version: "#{portefaix_version}"
  tag portefaix_section: "#{portefaix_section}"
  tag portefaix_req: "#{portefaix_req}"
  
  ref "Portefaix AWS #{portefaix_version}, #{portefaix_section}"

  describe aws_vpc(vpc_id) do
    it { should exist }
    its ('state') { should eq 'available' }
    it { should_not be_default }
    its('tags') { should include(
      'service' => 'vpc',
      'made-by' => 'terraform'
    )}
  end

end

# VPC.2
# =======================================================

portefaix_req = "#{portefaix_section}.2"

control "portefaix-aws-#{portefaix_version}-#{portefaix_req}" do
  title "Ensure that VPC have an Internet Gateway"
  impact 1.0

  tag standard: "portefaix"
  tag portefaix_version: "#{portefaix_version}"
  tag portefaix_section: "#{portefaix_section}"
  tag portefaix_req: "#{portefaix_req}"

  aws_internet_gateways.ids.each do |id|
    describe aws_internet_gateway(id: id) do
      it { should be_attached }
      its('vpc_id') { should cmp vpc_id }
    end
  end

end

# VPC.3
# =======================================================

portefaix_req = "#{portefaix_section}.3"

control "portefaix-aws-#{portefaix_version}-#{portefaix_req}" do
  title "Check AWS Security Groups does not have undesirable rules"
  impact 1.0

  tag standard: "portefaix"
  tag portefaix_version: "#{portefaix_version}"
  tag portefaix_section: "#{portefaix_section}"
  tag portefaix_req: "#{portefaix_req}"

  aws_security_groups.group_ids.each do |group_id|
    describe aws_security_group(group_id) do
        it { should_not allow_in(port: 22, ipv4_range: '0.0.0.0/0') }
    end
  end

end

# VPC.4
# =======================================================

portefaix_req = "#{portefaix_section}.4"

control "portefaix-aws-#{portefaix_version}-#{portefaix_req}" do
  title "Ensure that VPC Subnets exists"
  impact 1.0
  
  tag standard: "portefaix"
  tag portefaix_version: "#{portefaix_version}"
  tag portefaix_section: "#{portefaix_section}"
  tag portefaix_req: "#{portefaix_req}"

  aws_subnets.where(vpc_id: vpc_id).subnet_ids.each do |subnet|
    describe aws_subnet(subnet) do
      it { should be_available }
      # its('states') { should_not include 'pending' }
      # it { should_not be_mapping_public_ip_on_launch }
      # its ('cidr_block') { should cmp subnets_list[subnet]['subnet_cidr'] }
      # its ('availability_zone') { should cmp subnets_list[subnet]['subnet_az']}
    end
    # only_if { name = /private/ }
  end
end
