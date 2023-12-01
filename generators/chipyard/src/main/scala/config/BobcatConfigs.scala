package chipyard

import org.chipsalliance.cde.config.{Config}
import freechips.rocketchip.devices.tilelink.{BootROMLocated}
import freechips.rocketchip.subsystem._

// ---------------------
// Bobcat Configs
// ---------------------
class LittleBobcatConfig extends Config(
  new boom.common.WithVector(1) ++
    new boom.common.WithBoomDebugHarness ++                        // Enable debug harness
    new WithCustomBootROM ++                                       // Use custom BootROM to enable COSIM
    new chipyard.config.WithBroadcastManager ++ // no l2
    new boom.common.WithNLittleBooms(1) ++                          // small boom config
    new chipyard.config.AbstractConfig)

class ChangeExtMemBase(address: BigInt) extends Config((site, here, up) => {
  case ExtMem => up(ExtMem, site).map(x => x.copy(master = x.master.copy(base = address)))
})

class MicroBobcatConfig extends Config(
  new boom.common.WithVector(1) ++
    new boom.common.WithBoomDebugHarness ++ // Enable debug harness
    new WithCustomBootROM ++ // Use custom BootROM to enable COSIM
    new chipyard.config.WithTLSerialLocation(freechips.rocketchip.subsystem.FBUS, freechips.rocketchip.subsystem.SBUS) ++
    // new freechips.rocketchip.subsystem.WithIncoherentBusTopology ++
    //new freechips.rocketchip.subsystem.WithNBanks(0) ++ // remove L2$
    new testchipip.WithBackingScratchpad(base = 0x80000000L, mask = (128 << 10) - 1) ++
    // new freechips.rocketchip.subsystem.WithNoMemPort ++ // remove backing memory
    new freechips.rocketchip.subsystem.WithDefaultSlavePort ++
    new freechips.rocketchip.subsystem.WithoutTLMonitors ++
    new ChangeExtMemBase(0x90000000L) ++
    new chipyard.config.WithBroadcastManager ++ // no l2
    new boom.common.WithNLittleBooms(1) ++ // small boom config
    new chipyard.config.AbstractConfig)

class SmallBobcatConfig extends Config(
  new boom.common.WithVector(1) ++
  new boom.common.WithBoomDebugHarness ++                        // Enable debug harness
  new WithCustomBootROM ++                                       // Use custom BootROM to enable COSIM
  new boom.common.WithNSmallBooms(1) ++                          // small boom config
  new chipyard.config.AbstractConfig)

class MediumBobcatConfig extends Config(
  new boom.common.WithVector(2) ++
  new boom.common.WithBoomDebugHarness ++                        // Enable debug harness
  new WithCustomBootROM ++                                       // Use custom BootROM to enable COSIM
  new boom.common.WithNMediumBooms(1) ++                          // small boom config
  new chipyard.config.AbstractConfig)

class LargeBobcatConfig extends Config(
  new boom.common.WithVector(3) ++
  new boom.common.WithBoomDebugHarness ++                        // Enable debug harness
  new WithCustomBootROM ++                                       // Use custom BootROM to enable COSIM
  new boom.common.WithNLargeBooms(1) ++                          // small boom config
  new chipyard.config.AbstractConfig)

class MegaBobcatConfig extends Config(
  new boom.common.WithVector(4) ++
  new boom.common.WithBoomDebugHarness ++                        // Enable debug harness
  new WithCustomBootROM ++                                       // Use custom BootROM to enable COSIM
  new boom.common.WithNMegaBooms(1) ++                          // small boom config
  new chipyard.config.AbstractConfig)

