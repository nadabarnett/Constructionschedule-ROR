#-- copyright
# OpenProject Global Roles Plugin
#
# Copyright (C) 2010 - 2014 the OpenProject Foundation (OPF)
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# version 3.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
#++

require File.dirname(__FILE__) + '/../spec_helper'

describe Principal, type: :model do
  describe 'ATTRIBUTES' do
    before :each do
    end

    it { is_expected.to have_many :principal_roles }
    it { is_expected.to have_many :global_roles }
  end

  describe 'WHEN deleting a principal' do
    let(:principal) { FactoryBot.build(:user) }
    let(:role) { FactoryBot.build(:global_role) }

    before do
      FactoryBot.create(:principal_role, role: role,
                                          principal: principal)
      principal.destroy
    end

    it { expect(Role.find_by_id(role.id)).to eq(role) }
    it { expect(PrincipalRole.where(id: principal.id)).to eq([]) }
  end
end
