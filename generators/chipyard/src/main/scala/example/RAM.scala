package chipyard.example

import chisel3._
import chisel3.util._
import freechips.rocketchip.subsystem.{BaseSubsystem, CacheBlockBytes}
import org.chipsalliance.cde.config.{Parameters, Field, Config}
import freechips.rocketchip.diplomacy._
import freechips.rocketchip.tilelink._

case class MySRAMConfig(base: BigInt, size: BigInt)

case object MySRAMKey extends Field[Option[MySRAMConfig]](None)

class WithMySRAMKey(base: BigInt = 0x80000000L, size: BigInt = 0x4000) extends Config((site, here, up) => {
  case MySRAMKey =>
    Some(MySRAMConfig(base, size))
})

trait CanHavePeripheryMyRAM { this: BaseSubsystem =>
  implicit val p: Parameters

  p(MySRAMKey) .map { k =>
    val mysram = LazyModule(new TLRAM(
      address = AddressSet(k.base, k.size-1),
      beatBytes=mbus.beatBytes)(p))
    mbus.coupleTo("slave_named_mytlram") {
      mysram.node := TLFragmenter(mbus.beatBytes, mbus.blockBytes) := TLBuffer() := _
    }
  }
}
