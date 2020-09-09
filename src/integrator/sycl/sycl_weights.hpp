#pragma once
#include <SYCL/sycl.hpp>

#include <gauxc/gauxc_config.hpp>
#include <gauxc/shell.hpp>
#include <gauxc/enums.hpp>

namespace GauXC      {
    namespace integrator {
        namespace sycl       {

            template <typename F>
            void partition_weights_sycl_SoA(
                XCWeightAlg weight_alg, size_t npts, size_t natoms, const F *points_device,
                const int32_t *iparent_device, const F *dist_nearest_device,
                const F *rab_device, const F *atomic_coords_device, F *weights_device,
                F *dist_scratch_device, sycl::queue *stream);
        }
    }
}
