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

require 'spec_helper'

describe 'users/_available_global_roles' do
  let(:user)         { FactoryBot.create :user }
  let(:global_roles) { FactoryBot.create_list :global_role, 3 }

  it 'links to the principal roles controller using a path, not a URL' do
    render partial: 'users/available_global_roles',
           locals: { user: user,
                     global_roles: global_roles }

    expect(response.body).not_to match principal_roles_url
    expect(response.body).to match principal_roles_path
  end
end
