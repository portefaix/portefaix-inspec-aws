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
#
# SPDX-License-Identifier: Apache-2.0

trail_name = attribute("trail_name")

portefaix_version = input('portefaix_version')
portefaix_section = 'cloudtrail'

title "Cloudtrail standards"

# CLOUDTRAIL.1
# =======================================================

portefaix_req = "#{portefaix_section}.1"

control "portefaix-aws-#{portefaix_version}-#{portefaix_req}" do
  title "Ensure that Cloudtrail exist and tags correcly set"
  impact 1.0

  tag standard: "portefaix"
  tag portefaix_version: "#{portefaix_version}"
  tag portefaix_section: "#{portefaix_section}"
  tag portefaix_req: "#{portefaix_req}"
  
  ref "Portefaix AWS #{portefaix_version}, #{portefaix_section}"

  describe aws_vpc(trail_name) do
    it { should exist }
    its ('state') { should eq 'available' }
    it { should_not be_default }
  end

end
