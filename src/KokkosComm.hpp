//@HEADER
// ************************************************************************
//
//                        Kokkos v. 4.0
//       Copyright (2022) National Technology & Engineering
//               Solutions of Sandia, LLC (NTESS).
//
// Under the terms of Contract DE-NA0003525 with NTESS,
// the U.S. Government retains certain rights in this software.
//
// Part of Kokkos, under the Apache License v2.0 with LLVM Exceptions.
// See https://kokkos.org/LICENSE for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//@HEADER

#pragma once

#include "KokkosComm_version.hpp"

#include <Kokkos_Core.hpp>

#include "KokkosComm_pack_traits.hpp"
#include "KokkosComm_traits.hpp"

#include "KokkosComm_request.hpp"
#include "KokkosComm_collective.hpp"

#include "impl/KokkosComm_isend.hpp"
#include "impl/KokkosComm_recv.hpp"
#include "impl/KokkosComm_send.hpp"

namespace KokkosComm {

template <typename SendView, typename ExecSpace>
Req isend(const ExecSpace &space, const SendView &sv, int dest, int tag,
          MPI_Comm comm) {
  return Impl::isend(space, sv, dest, tag, comm);
}

template <typename SendView, typename ExecSpace>
void send(const ExecSpace &space, const SendView &sv, int dest, int tag,
          MPI_Comm comm) {
  return Impl::send(space, sv, dest, tag, comm);
}

template <typename Recv, typename ExecSpace>
void recv(const ExecSpace &space, Recv &sv, int src, int tag, MPI_Comm comm) {
  return Impl::recv(space, sv, src, tag, comm);
}

}  // namespace KokkosComm
