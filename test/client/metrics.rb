

# max values used by cyberdojo/check-test-results image
# which is called from scripts/test_in_containers.sh

MAX = {
  failures:0,
  errors:0,
  warnings:2,
  skips:0,

  duration:20,

  app: {
    lines: {
       total:69,
      missed:0,
    },
    branches: {
       total:2,
      missed:1,
    }
  },

  test: {
    lines: {
       total:0,
      missed:0,
    },
    branches: {
       total:0,
      missed:0,
    }
  }
}
