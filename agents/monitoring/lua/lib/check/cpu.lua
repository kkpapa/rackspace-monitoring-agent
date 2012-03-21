local BaseCheck = require('./base').BaseCheck
local CheckResult = require('./base').CheckResult
local Metric = require('./base').Metric

local CpuCheck = BaseCheck:extend()

function CpuCheck:initialize(params)
  BaseCheck.initialize(self, params, 'agent.cpu')
end

function CpuCheck:run(callback)
  -- Perform Check
  local s = sigar:new()
  local cpuinfo = s:cpus()
  local metrics = {}
  local checkResult = CheckResult:new(self, {})

  for i=1, #cpuinfo do
    for key, value in pairs(cpuinfo[i]:data()) do
      checkResult:addMetric(key, nil, i, value)
    end
  end

  -- Return Result
  self._lastResults = checkResult
  callback(checkResult)
end

local exports = {}
exports.CpuCheck = CpuCheck
return exports
