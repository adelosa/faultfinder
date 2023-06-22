@echo off
clipper %1
rtlink file %1,..\common\obj\control,.\obj\register lib ct
