#-- copyright
# OpenProject Reporting Plugin
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

require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe CostQuery, type: :model, reporting_query_helper: true do
  minimal_query

  before do
    FactoryBot.create(:admin)
    project = FactoryBot.create(:project_with_types)
    work_package = FactoryBot.create(:work_package, project: project)
    FactoryBot.create(:time_entry, work_package: work_package, project: project)
  end

  describe CostQuery::Transformer do
    it "should walk down row_first" do
      @query.group_by :work_package_id
      @query.column :tweek
      @query.row :project_id
      @query.row :user_id

      result = @query.transformer.row_first.values.first
      [:user_id, :project_id, :tweek].each do |field|
        expect(result.fields).to include(field)
        result = result.values.first
      end
    end

    it "should walk down column_first" do
      @query.group_by :work_package_id
      @query.column :tweek
      @query.row :project_id
      @query.row :user_id

      result = @query.transformer.column_first.values.first
      [:tweek, :work_package_id].each do |field|
        expect(result.fields).to include(field)
        result = result.values.first
      end
    end
  end
end
