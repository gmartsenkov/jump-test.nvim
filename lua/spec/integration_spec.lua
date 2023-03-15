local jump = require "jump-test"

describe("find_spec", function()
  it("returns the correct spec path", function ()
    local work_dir = "/dev/backend-api"
    local config = { excluded_paths = {"lib", "apps"} }
    local tests = {
      {
        "/dev/backend-api/lib/uplisting/rom/repositories/invitation.rb",
        "/dev/backend-api/spec/uplisting/rom/repositories/invitation_spec.rb"
      },
      {
        "/dev/backend-api/apps/guests/controllers/payment/new.rb",
        "/dev/backend-api/spec/guests/controllers/payment/new_spec.rb"
      },
      {
        "/dev/backend-api/lib/uplisting/entities/report.rb",
        "/dev/backend-api/spec/uplisting/entities/report_spec.rb"
      }
    }

    for _, test in ipairs(tests) do
      assert.are.same(jump.find_spec(test[1], work_dir, config), {test[2]})
    end
  end)

  it("returns the correct implementation path", function()
    local work_dir = "/dev/backend-api"
    local config = { excluded_paths = {"lib", "apps"} }
    local tests = {
      {
        "/dev/backend-api/spec/uplisting/rom/repositories/invitation_spec.rb",
        {
          "/dev/backend-api/lib/uplisting/rom/repositories/invitation.rb",
          "/dev/backend-api/apps/uplisting/rom/repositories/invitation.rb"
        }
      },
      {
        "/dev/backend-api/spec/guests/controllers/payment/new_spec.rb",
        {
          "/dev/backend-api/lib/guests/controllers/payment/new.rb",
          "/dev/backend-api/apps/guests/controllers/payment/new.rb"
        }
      },
      {
        "/dev/backend-api/spec/uplisting/entities/report_spec.rb",
        {
          "/dev/backend-api/lib/uplisting/entities/report.rb",
          "/dev/backend-api/apps/uplisting/entities/report.rb"
        }
      }
    }

    for _, test in ipairs(tests) do
      assert.are.same(jump.find_spec(test[1], work_dir, config), test[2])
    end
  end)
end)
